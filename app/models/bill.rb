class Bill < ApplicationRecord
    self.primary_key = 'id'
    
    has_many :tags
    has_many :subjects, through: :tags
    has_many :votes, as: :votable
end
