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

    def vote_count party, position
    end

    def majority_position party=nil
      
    end
end
