class PositionSerializer < ActiveModel::Serializer
  attributes :id, :vote_position, :vote_id, :member_id
end
