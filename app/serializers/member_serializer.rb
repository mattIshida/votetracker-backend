class MemberSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :short_title, :party, :congress, :positions

  def positions
    object.positions.order(vote_id: :desc).select([:id, :vote_position])
  end

  #has_many :positions, scope: Proc.new { |a| a.order(id: :desc) }#, serializer: PositionSerializer
end
