class Vote < ApplicationRecord
    self.primary_key = 'id'

    #belongs_to :votable, polymorphic: true
    # belongs_to :bill, as: votable, class_name: "Bill"
    #has_many :votables, polymorphic: true
    has_many :positions
    has_many :subjects, through: :votable

    def bill
        Bill.find_by(id: self.votable_id)
    end

    def nomination
        Nomination.find_by(id: self.votable_id)
    end

    def votable
        return self.bill if self.votable_type == 'Bill'
        return self.nomination if self.votable_type == 'Nomination'
    end

    def party_summary party=nil
        return tabulate(self.positions) unless party
        tabulate(self.positions.filter {|p| p.party == party})
    end

    def summary
        summary_hsh = Hash.new
        for p in self.positions.map(&:party).uniq do
            summary_hsh[p] = party_summary p
        end
        summary_hsh["Total"] = party_summary
        summary_hsh
    end
 

    def tabulate arr
        tab = {"Total"=>0}
        arr.each do |x|
            tab[x.vote_position] = 0 unless tab.has_key?(x.vote_position)
            tab[x.vote_position] += 1
            tab["Total"] += 1
        end
        tab
    end
end
