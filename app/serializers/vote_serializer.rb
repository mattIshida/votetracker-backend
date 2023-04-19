class VoteSerializer < ActiveModel::Serializer
  attributes :id, :votable_id, :votable_type, :date, :result, :description, :question, :votable, :summary, :roll_call, :year, :month
end
