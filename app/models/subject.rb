class Subject < ApplicationRecord
    has_many :tags
    has_many :bill, through: :tags
end
