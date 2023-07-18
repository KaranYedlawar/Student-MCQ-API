class AccountsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def sms_confirm
        token = request.headers['token']&.split&.last
        if token
            payload= JWT.decode(token, nil, false).first
            if payload.present? && payload['exp'] >= Time.now.to_i
                current_user = User.find_by(id: payload['sub'])
                if current_user.otp_verified == nil
                    sms_service = Twilio::SmsService.new(to: current_user.full_phone_number, pin: sms_verification_params[:pin])
                    verification_check = sms_service.verify_otp
                    if verification_check == {:status=>"approved"}
                        current_user.update(otp_verified: true)
                        render json: {
                        message: "OTP verified successfully.",
                        token: token
                        }, status: :ok
                    else
                        render json: {
                        message: "Invalid OTP, check again."
                        }, status: 404
                    end
                else
                    render json:{
                        message:"OTP is already verified with that token, you can proceed with academics"
                    }
                end
            end
        else
            render json: {
                message: "Invalid Token"
            }, status: 401
        end
    end

    private

    def sms_verification_params
        params.permit(:pin)
    end
end
    