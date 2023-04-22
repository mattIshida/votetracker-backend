class MemberSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :short_title, :party, :congress, :positions, :state, :district

  def positions
  
    paginated_positions = Position.joins(:vote).where({vote: {year: @instance_options[:year], month: @instance_options[:month]}, member_id: object.id}).order(vote_id: :desc).select([:vote_position, :vote_id]).paginate(page: @instance_options[:page], per_page: @instance_options[:per_page])
    #paginated_positions = Position.joins(:vote).where({vote: {year: @instance_options[:year], month: @instance_options[:month]}, member_id: object.id}).order(vote_id: :desc).select([:vote_position]).paginate(page: @instance_options[:page], per_page: @instance_options[:per_page])
    total_pages = paginated_positions.total_pages
    current_page = paginated_positions.current_page
    
    {
      positions: paginated_positions,
      total_pages: total_pages, 
      current_page: current_page
    }
    # (0...25).to_a
    #limit(@instance_options[:per_page]).offset(@instance_options[:offset])
  end

  #has_many :positions, scope: Proc.new { |a| a.order(id: :desc) }#, serializer: PositionSerializer
end
