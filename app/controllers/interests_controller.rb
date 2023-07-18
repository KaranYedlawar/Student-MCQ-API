class InterestsController < ApplicationController

    def index
        interest =Interest.all 
        if interest.empty?
            render json:{
                message: "No interest found",
                interest: []
            }, status: :not_found
        else
            render json:{
                message: "All existing interests..",
                interest: interest
            }, status: :ok
        end
    end

    def create
        if current_user.admin?
            interest = Interest.create(interest_params)
            if interest.save
                render json:{
                    message: "Interest created successfully.",
                    interest:interest
                }, status: :created
            else
                render json:{
                    message: "Unable to create interest, check again!",
                    error: interest.errors.full_messages
                }, status: 422
            end
        end
    end

    private
    def set_interest
        interest = Interest.find_by(id: params[:id])
        if interest
            return interest
        end
    end

    def interest_params
        params.require(:interest).permit(:name)
    end
end
