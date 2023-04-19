class Nomination < ApplicationRecord
    self.primary_key = 'id'
    has_many :votes, as: :votable
end
