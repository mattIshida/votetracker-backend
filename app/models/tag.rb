class Tag < ApplicationRecord
    belongs_to :subject
    belongs_to :bill
end
