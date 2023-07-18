class AcademicsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        academic = Academic.all 
        if academic.empty?
            render json:{
                message: "No academic found",
                academic: []
            }, status: :not_found
        else
            render json:{
                message: "Academics Details",
                academic: DocumentSerializer.new(academic)
            }, status: :ok
        end
    end

    def create
        token = request.headers['token']&.split&.last
        if token
            payload= JWT.decode(token, nil, false).first
            if payload.present? && payload['exp'] >= Time.now.to_i
                current_user = User.find_by(id: payload['sub'])
                academic = Academic.create(academic_params)
                if academic.save
                    current_user.update(academic_status: true)
                    render json:{
                        message: "academic created successfully.",
                        academic: DocumentSerializer.new(academic)
                    }, status: :created
                else
                    render json:{
                        message: "Unable to create academic, check again!",
                        error: academic.errors.full_messages
                    }, status: 422
                end
            end
        else
            render json: {
                message: "Invalid Token"
            }, status: 401
        end
    end

    private
    def set_academic
        academic = Academic.find(id: params[:id])
        if academic
            return academic
        end
    end

    

    def academic_params
        current_user_id = current_user.id
        params.permit(:interest_id, :qualification_id, :government_id, :cv, :college_name, :career_goals, :known_languages, :other_languages, :currently_working, :specialization, :total_experience, :availability).merge(user_id: current_user_id)
    end
end