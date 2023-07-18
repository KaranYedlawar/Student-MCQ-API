class UsersController < ApplicationController
    def index
        user =User.all 
        if user.empty?
            render json:{
                message: "No user found",
                user: []
            }, status: :not_found
        else
            render json:{
                message: "All existing users..",
                user: user
            }, status: :ok
        end
    end

    def create
        user = User.create(user_params)
        if user.save
            render json:{
                message: "User profile created successfully.",
                user:user
            }, status: :created
        else
            render json:{
                message: "Unable to create user, check details again!",
                error: user.errors.full_messages
            }, status: 422
        end
    end

    def show
        user = set_user
        if user
            render json:{
                message:"User found",
                user:user
            }, status: :ok
        else
            render json:{
                message:"User not found",
                user:[]
            }, status: :not_found
        end
    end
    
    def destroy
        user = set_user
        if user.present?
            user.delete
            render json:{
                message:"User deleted successfully",
                user: user
            }, status: :ok
        else
            render json:{
                message:"User not found to delete",
                user:[]
            }, status: :not_found
        end
    end

    private
    def set_user
        user = User.find_by(id: params[:id])
        if user
            return user
        end
    end

    def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name, :full_phone_number, :gender, :role, :country, :city, :state, :address)
    end
end
