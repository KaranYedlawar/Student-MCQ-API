class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token
  
  def create
    build_resource(sign_up_params)
    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        Twilio::SmsService.new(to: resource.full_phone_number, pin: '').send_otp
        sign_up(resource_name, resource)
        token = request.env['warden-jwt_auth.token']
        response_data = {
          message: "User created successfully, Verify OTP.",
          meta: {
          token: token
          }
        }
        render json: response_data
      else
        render json: { status: { code: 401, message: "User is not active" } }
      end

    else
      existing_user = User.find_by(email: resource.email)
      if existing_user
        if existing_user.academic.present?
          response = {
          data: { 
            id: existing_user.id, 
            type: "sms_otp", 
            errors: {account: "Account already exists"}
            }
          }
          render status: 200, json: response 
       else
          existing_user.full_phone_number = params[:data][:user][:full_phone_number]
          token = existing_user.generate_jwt
          Twilio::SmsService.new(to:existing_user.full_phone_number, pin: '').send_otp
          response = {
            data: { 
              id: existing_user.id, 
              type: "sms_otp", 
              meta: { token: token }, 
              errors: {account: "Account already exists, Verification code has been sent on your phone number, Please verify your phone number number to activate your account"}
            }
          }
          render status: 200, json: response 
       end
      else
        render status: 422, json: {errors: resource.errors.full_messages}
      end
    end
  end
  
  
  
  
  private
  
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :full_phone_number, :email, :gender, :role, :country, :city, :state, :address, :password)
  end
end
