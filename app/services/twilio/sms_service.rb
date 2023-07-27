require 'twilio-ruby'

module Twilio
    class SmsService
            
        def initialize(to:, pin:)
            @to = to
            @pin = pin
        end

        def send_otp
            account_sid = 'AC4e1ded9186685a56f8f40d975a8adcba'
            auth_token = '35d6b8d9030a865c6ec3818c35444c69'
            from = '+18145244996'
            @client = Twilio::REST::Client.new(account_sid, auth_token)
            verification = @client.verify
                            .v2
                            .services('VAc90a53ad565435d901178f6d1e232cfc')
                            .verifications
                            .create(to: @to, channel: 'sms')
        end

        def verify_otp
            account_sid = 'AC4e1ded9186685a56f8f40d975a8adcba'
            auth_token = '35d6b8d9030a865c6ec3818c35444c69'
            @client = Twilio::REST::Client.new(account_sid, auth_token)
            verification_check = @client.verify
                           .v2
                           .services('VAc90a53ad565435d901178f6d1e232cfc')
                           .verification_checks
                           .create(to: @to, code: @pin)
           return  {status: verification_check.status}
       end
    end
end
