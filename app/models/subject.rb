class Subject < ApplicationRecord
    has_many :tags
    has_many :bills, through: :tags
end
