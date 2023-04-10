class Vote < ApplicationRecord
    self.primary_key = 'id'

    belongs_to :bill
    has_many :positions
    has_many :subjects, through: :bill
end
