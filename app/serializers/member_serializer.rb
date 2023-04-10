class MemberSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :short_title, :party, :congress

  has_many :positions
end
