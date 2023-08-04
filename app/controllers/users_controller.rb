class UsersController < ApplicationController
    def index
      users = User.all
      if users.empty?
        render json: {
          message: "No users found",
          users: []
        }, status: :not_found
      else
        render json: {
          message: "All existing users",
          users: users
        }, status: :ok
      end
    end
  
    def create
      user = User.create(user_params)
      if user.save
        render json: {
          message: "User profile created successfully",
          user: user
        }, status: :created
      else
        render json: {
          message: "Unable to create user, check details again!",
          errors: user.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  
    def show
      user = set_user
      if user
        render json: {
          message: "User found",
          user: user
        }, status: :ok
      else
        render json: {
          message: "User not found",
          user: []
        }, status: :not_found
      end
    end
  
    def destroy
      user = set_user
      if user
        if user.destroy
          render json: {
            message: "User deleted successfully",
            user: user
          }, status: :ok
        else
          render json: {
            message: "Unable to delete user",
            user: user
          }, status: :unprocessable_entity
        end
      else
        render json: {
          message: "User not found to delete",
          user: []
        }, status: :not_found
      end
    end
  
    private
  
    def set_user
      user = User.find_by(id: params[:id])
      return user 
    end
  
    def user_params
      params.require(:user).permit(:email, :password, :first_name, :last_name, :full_phone_number, :gender, :role, :country, :city, :state, :address)
    end
end
  