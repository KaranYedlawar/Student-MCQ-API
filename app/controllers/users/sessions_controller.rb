class Users::SessionsController < Devise::SessionsController

  skip_before_action :verify_authenticity_token
  respond_to :json
  private

  def respond_with(user, options={})

    if user.valid_password?(params[:user][:password]) && user.academic_status == true && user.otp_verified == true
      sign_in user
      token = request.env['warden-jwt_auth.token']
      user.update(login_status: true)
      render json:{
      status:{ code:200, message:"User signed in successfully",
      data: current_user},
      token: token
        }, status: :ok
    else
      render json: {
        message: "Failed to sign-in. Check OTP is verified and Academic form is filled."
        }, status: 401
    end
  end

  def respond_to_on_destroy
    token = request.headers['token']&.split&.last
    if token
      payload= JWT.decode(token, nil, false).first
      if payload.present? && payload['exp'] >= Time.now.to_i
        current_user = User.find_by(id: payload['sub'])
        if current_user
          current_user.update(login_status: false)
          render json:{
          message:"User Logged out successfully"
          }, status: :ok
        else
          render json:{
          status:401,
          message:"User has no active session"
          }, status: :unauthorized
        end
      end
    else
      render json: {
            message: "Invalid Token"
      }, status: 401
    end
  end
end
