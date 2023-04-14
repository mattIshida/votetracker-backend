class MembersController < ApplicationController

    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        @members = Member.all
        # @positions = Position.paginate(page: 1, per_page: 10)
        render json: @members, Serializer: MemberSerializer, page: page, per_page: per_page
#         render json: {
#     authors: ActiveModelSerializers::SerializableResource.new(
#       @members,
#       each_serializer: MemberSerializer,
#       scope: { paginated_articles: @positions }
#     ),
#     meta: {
#       current_page: @positions.current_page,
#       total_pages: @positions.total_pages,
#       total_count: @positions.total_entries
#     }
#   }
    end

end
