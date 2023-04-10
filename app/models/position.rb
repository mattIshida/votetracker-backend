class Position < ApplicationRecord
    belongs_to :member
    belongs_to :vote
end
