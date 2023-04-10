class MembersController < ApplicationController

    def index
        members = Member.all
        render json: members, Serializer: MemberSerializer
    end
    
end
