class VotesController < ApplicationController

    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10

        votes = Vote.all.order(id: :desc).paginate(page: page, per_page: per_page)
        render json: votes
    end
end
