class MembersController < ApplicationController

    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        @members = Member.all.limit(1000)
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


    def get_month
        page = params[:page] || 1
        per_page = params[:per_page] || 25
        chamber = params[:chamber] || 'house'
        year = params[:year] || '2023'
        month = params[:month] || '01'
        congress = (year.to_i - 1787)/2

        @members = Member.where(congress: congress, chamber: chamber)
        response.headers['Content-Type'] = 'text/html'

        render json: @members, Serializer: MemberSerializer, page: page, per_page: per_page, year: year, month: month
    end

end
