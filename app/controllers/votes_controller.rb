class VotesController < ApplicationController

    def index
        page = params[:page] || 1
        per_page = params[:per_page] || 10

        votes = Vote.all.order(id: :desc).paginate(page: page, per_page: per_page)
        render json: votes
    end

    def get_month
        page = params[:page] || 1
        per_page = params[:per_page] || 25
        chamber = params[:chamber] || 'house'
        year = params[:year] || '2023'
        month = params[:month] || '01'
        congress = (year.to_i - 1787)/2

        votes = Vote.where(congress: congress.to_i, chamber: chamber.capitalize, year: year, month: month).paginate(page: page, per_page: per_page)
        render json: votes
    end

    def vote_count
        tally = Vote.group(:chamber, :year, :month).order({year: :desc, month: :desc}).count.map{ |k, v| {chamber: k[0].downcase, year: k[1], month: k[2], count: v}}
        render json: tally
    end

end
