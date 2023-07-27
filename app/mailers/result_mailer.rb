class ResultMailer < ApplicationMailer
    default from: 'no-reply@example.com'

    require 'email_validator'
  
    def result_email(user, score)
      @user = user
      @score = score
  
      if valid_email?(@user.email) && valid_gmail_domain?(@user.email)
        mail(to: @user.email, subject: 'MCQ Result') do |format|
          format.text { render plain: "Hello, #{user.first_name}!\nYour MCQ test score: #{score}%" }
        end
      else
        Rails.logger.error("Invalid email address format or not a Gmail address: #{user.email}")
      end
    end
  
    private
  
    def valid_email?(email)
      EmailValidator.valid?(email)
    end
  
    def valid_gmail_domain?(email)
      domain = email.split('@').last
      domain == 'gmail.com'
    end
end
