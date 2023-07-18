require 'twilio-ruby'

module Twilio
    class SmsService
            
        def initialize(to:, pin:)
            @to = to
            @pin = pin
        end

        def send_otp
            account_sid = 'AC4e1ded9186685a56f8f40d975a8adcba'
            auth_token = 'cec4d006e98817e2b7231558eeebb128'
            from = '+18145244996'
            @client = Twilio::REST::Client.new(account_sid, auth_token)
            verification = @client.verify
                            .v2
                            .services('VA77aaf047be4def67dcd72ecb6d266b66')
                            .verifications
                            .create(to: @to, channel: 'sms')
        end

        def verify_otp
            account_sid = 'AC4e1ded9186685a56f8f40d975a8adcba'
            auth_token = 'cec4d006e98817e2b7231558eeebb128'
            @client = Twilio::REST::Client.new(account_sid, auth_token)
            verification_check = @client.verify
                           .v2
                           .services('VA77aaf047be4def67dcd72ecb6d266b66')
                           .verification_checks
                           .create(to: @to, code: @pin)
           return  {status: verification_check.status}
       end
    end
end
