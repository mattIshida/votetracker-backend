namespace :refresh_data do
    desc "Refreshing data!'"
    task refresh_all: :environment  do
        puts "Starting refresh"

        Time.zone = "America/New_York"
        current_time_in_dc = Time.now.in_time_zone

        current_month = current_time_in_dc.strftime('%m')
        current_year = current_time_in_dc.year
        current_congress = (current_year - 1787)/2
        current_session = current_year % 2 == 1 ? 1 : 2
        
        API_KEY = Rails.application.credentials.propublica[:api_key]

        def fetch_json url
            JSON.parse(URI.open(url, "X-API-Key"=> API_KEY).read)
        end

        def create_instance model, hsh
            keys_needed = model.column_names
            model.create(hsh.filter {|k, _| keys_needed.include?(k)})
        end

        def fetch_members chamber, congress
            url = "https://api.propublica.org/congress/v1/#{congress}/#{chamber}/members.json"
            fetch_json(url)["results"].first["members"].map {|h| h.merge({"chamber" => chamber, "congress" => congress})}
        end

        def fetch_votes chamber, yyyy, mm
            url = "https://api.propublica.org/congress/v1/#{chamber}/votes/#{yyyy}/#{"%02d" % mm}.json"
            fetch_json(url)['results']['votes']
            .map {|h| h.merge({
                "id" => "#{h["chamber"]}-#{h["congress"]}-#{h["session"]}-#{h["roll_call"].to_s.rjust(4,"0")}", 
                "year"=> /^[0-9]{4}/.match(h["date"]).to_s, 
                "month"=>/(?<=-)[0-9]{2}(?=-)/.match(h['date']).to_s
                }
            )}
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

        def fetch_positions chamber, congress, session, roll_call
            url = "https://api.propublica.org/congress/v1/#{congress}/#{chamber}/sessions/#{session}/votes/#{roll_call}.json"
            fetch_json(url)["results"]["votes"]["vote"]["positions"]
        end

        def update_chamber chamber, year, month, congress
            new_votes = fetch_votes(chamber, year, month).filter {|h| Vote.find_by(roll_call: h["roll_call"]).nil? }
            new_members = fetch_members(chamber, congress).filter {|h| Member.find_by(id: h["id"]).nil?}

            puts "New votes: #{new_votes.length}"
            new_vote_instances = new_votes.map {|h| create_instance(Vote, h)}
            puts "New members: #{new_members.length}"
            new_members&.each {|h| create_instance(Member, h)}

            puts "Creating new positions"
            for v in new_vote_instances do
                positions = fetch_positions(v.chamber, v.congress, v.session, v.roll_call)
                if positions.length == 0 
                    v.destroy
                else 
                    positions.each do |p|
                    Position.create(
                        member_id: p["member_id"],
                        vote_id: v.id, 
                        vote_position: p["vote_position"],
                        party: p["party"]
                    )
                    end
                end
            end
        end

        ['house', 'senate'].each do |c|
            update_chamber( c, current_year, current_month, current_congress)
        end

        # new_votes = fetch_votes('house', current_year, current_month).filter {|h| Vote.find_by(roll_call: h["roll_call"]).nil? }
        # new_members = fetch_members('house', current_congress).filter {|h| Member.find_by(id: h["id"]).nil?}
        # puts(new_votes)
        # puts(new_members)

        # new_vote_instances = new_votes.map {|h| create_instance(Vote, h)}
        # new_members&.each {|h| create_instance(Member, h)}

        # for v in new_vote_instances do
        #     positions = fetch_positions(v.chamber, v.congress, v.session, v.roll_call)
        #     if positions.length == 0 
        #         v.destroy
        #     else 
        #         positions.each do |p|
        #         Position.create(
        #             member_id: p["member_id"],
        #             vote_id: v.id, 
        #             vote_position: p["vote_position"],
        #             party: p["party"]
        #         )
        #         end
        #     end
        # end
    end
  end