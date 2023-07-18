class OptionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        option = Option.all 
        if option.empty?
            render json:{
                message: "No option found",
                option: []
            }, status: :not_found
        else
            render json:{
                message: "All existing options..",
                choices: option.as_json(only: [:id, :choice, :question_id])
            }, status: :ok
        end
    end

    def create
        if current_user.admin?
            option = Option.create(option_params)
            if option.save
                render json:{
                    message: "option created successfully.",
                    option:option
                }, status: :created
            else
                render json:{
                    message: "Unable to create option, check details again!",
                    error: option.errors.full_messages
                }, status: 422
            end
        end
    end

    private
    def set_option
        option = Option.find_by(id: params[:id])
        if option
            return option
        end
    end

    def option_params
        params.require(:option).permit(:choice, :question_id)
    end
end
