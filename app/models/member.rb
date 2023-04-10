class Member < ApplicationRecord
    self.primary_key = 'id'
    has_many :positions
    has_many :votes, through: :positions
end
