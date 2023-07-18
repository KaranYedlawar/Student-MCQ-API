class QualificationsController < ApplicationController
    def index
        qualification = Qualification.all 
        if qualification.empty?
            render json:{
                message: "No qualification found",
                qualification: []
            }, status: :not_found
        else
            render json:{
                message: "All existing qualifications..",
                qualification: qualification
            }, status: :ok
        end
    end

    def create
        if current_user.admin?
            qualification = Qualification.create(qualification_params)
            if qualification.save
                render json:{
                    message: "qualification created successfully.",
                    qualification:qualification
                }, status: :created
            else
                render json:{
                    message: "Unable to create qualification, check again!",
                    error: qualification.errors.full_messages
                }, status: 422
            end
        end
    end

    private
    def set_qualification
        qualification = Qualification.find_by(id: params[:id])
        if qualification
            return qualification
        end
    end

    def qualification_params
        params.require(:qualification).permit(:name)
    end
end
