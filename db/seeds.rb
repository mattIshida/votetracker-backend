# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Member.destroy_all
Vote.destroy_all
Position.destroy_all
Bill.destroy_all
Subject.destroy_all
Tag.destroy_all
Nomination.destroy_all

API_KEY = Rails.application.credentials.propublica[:api_key]


def fetch_json url
    JSON.parse(URI.open(url, "X-API-Key"=> API_KEY).read)
end

def create_instance model, hsh
    keys_needed = model.column_names
    model.create(hsh.filter {|k, _| keys_needed.include?(k)})
end

puts 'Seeding members....'
def fetch_members chamber, congress
    url = "https://api.propublica.org/congress/v1/#{congress}/#{chamber}/members.json"
    fetch_json(url)["results"].first["members"].map {|h| h.merge({"chamber" => chamber, "congress" => congress})}
end

#fetch_members('house', 118).each {|h| create_instance(Member, h)}
fetch_members('senate', 118).each {|h| create_instance(Member, h)}


puts 'Seeding votes....'
def fetch_votes chamber, yyyy, mm
    url = "https://api.propublica.org/congress/v1/#{chamber}/votes/#{yyyy}/#{"%02d" % mm}.json"
    fetch_json(url)['results']['votes']
    .map {|h| h.merge({"id" => "#{h["chamber"]}-#{h["congress"]}-#{h["session"]}-#{h["roll_call"]}"})}
    .map do|h|
            if h.has_key?("bill")
                if !h["bill"].empty?
                    h["votable_type"] = 'Bill'
                    h["votable_id"] = h["bill"]["bill_id"]
                elsif /PN[0-9]*$/.match(h["question_text"])
                    h["votable_type"] = 'Nomination'
                    h["votable_id"] = /PN[0-9]*$/.match(h["question_text"]).to_s
                end   
            end
            h
        end
end

#fetch_votes('house', 2023, 4).each {|h| create_instance(Vote, h)}
fetch_votes('senate', 2023, 3).each {|h| create_instance(Vote, h)}



puts 'Seeding positions....'
def fetch_positions chamber, congress, session, roll_call
    url = "https://api.propublica.org/congress/v1/#{congress}/#{chamber}/sessions/#{session}/votes/#{roll_call}.json"
    fetch_json(url)["results"]["votes"]["vote"]["positions"]
end

for v in Vote.all do
    fetch_positions(v.chamber, v.congress, v.session, v.roll_call).each do |p|
        Position.create(
            member_id: p["member_id"],
            vote_id: v.id, 
            vote_position: p["vote_position"],
            party: p["party"]
        )
    end
end


puts 'Seeding votables...'
def fetch_bill congress, bill_id
    bill_slug = /^.*(?=-)/.match(bill_id)[0]
    url = "https://api.propublica.org/congress/v1/#{congress}/bills/#{bill_slug}.json"
    fetch_json(url)['results'].map {|h| h.merge({"id" => h["bill_id"]})}[0]
end 

def fetch_nomination congress, nomination_id
    url = "https://api.propublica.org/congress/v1/#{congress}/nominees/#{nomination_id}.json"
    pp url
    begin
        return fetch_json(url)['results'][0]
    rescue
        return nil
    end
end

for v in Vote.all do
    if v.votable_type == 'Bill'
        h = fetch_bill(v.congress, v.votable_id)
        create_instance(Bill, h) unless Bill.find_by(id: v.votable_id)
    elsif v.votable_type == 'Nomination'
        h = fetch_nomination(v.congress, v.votable_id)
        if h
            create_instance(Nomination, h) unless Nomination.find_by(id: v.votable_id)
        end
    end
end

puts 'Seeding subjects...'
def fetch_subjects bill_id
    bill_slug, congress = *bill_id.split('-')
    url = "https://api.propublica.org/congress/v1/#{congress}/bills/#{bill_slug}/subjects.json"
    result = fetch_json(url)
    # return [] if result['num_results'].to_i == 0
    # puts result['results']['subjects']
    result['results'][0]['subjects']
end

for b in Bill.all do
    fetch_subjects(b.id).each do |h|
        if h
            subject = Subject.find_or_create_by(name: h["name"], url_name: h["url_name"])
            Tag.create(bill_id: b.id, subject_id: subject.id)
        end
    end
end


# def create_vote hsh
#     keys_needed = Vote.column_names
#     Vote.create(hsh.filter {|k, _| keys_needed.include?(k)})
# end


# def create_members body, session
#     fetch_members(body, session)
#         .each {|m| Legislator.find_by(first_name: m[:first_name], last_name: m[:last_name], date_of_birth: m[:date_of_birth])||Legislator.create(m)}
# end

# (117..118).to_a.reverse.each do |c|
#     puts "Seeding Senate members for Congress ##{c}"
#     create_members('senate', c)    
#     #puts "Seeding House members"
#     #create_members('house', c)
# end