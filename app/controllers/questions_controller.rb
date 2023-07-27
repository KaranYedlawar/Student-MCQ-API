class QuestionsController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def index
        question = Question.all
        if question.empty?
            render json:{
                message: "No question found",
                question: []
            }, status: :not_found
        else
            paginated_questions = question.page(params[:page]).per(params[:per_page])
            render json: {
                message: "All questions..",
                current_page: paginated_questions.current_page,
                total_pages: paginated_questions.total_pages,
                questions: paginated_questions.as_json(only: [:id, :ques], include: { options: { only: [:choice] } })
              }, status: :ok
        end  
    end

    def create
        if current_user.admin?
            question = Question.create(question_params)
            if question.save
                render json:{
                    message: "question created successfully.",
                    question:question
                }, status: :created
            else
                render json:{
                    message: "Unable to create question, check details again!",
                    error: question.errors.full_messages
                }, status: 422
            end
        end
    end

    def update
        if current_user.admin?
            question = set_question
            if question.update(question_params)
                render json:{
                message: "Question Updated Successfully",
                question: question
                }, status: :ok
            else
                render json: {
                message: "Question unable to update",
                error: user.errors.full_messages
                }, status: 422
            end
        else
            render json:{
                message: "Only admin can update it!"
            }, status: 401
        end
    end

    def condition_based_question
        token = request.headers['token']&.split&.last
        if token
            payload= JWT.decode(token, nil, false).first
            if payload.present? && payload['exp'] >= Time.now.to_i
                current_user = User.find_by(id: payload['sub'])
                if current_user.login_status == true
                    if current_user.role == 'student'
                        difficulty_level = params[:difficulty_level]
                        language = params[:language]
                        quest = Question.where("difficulty_level LIKE ? AND language LIKE ?", "%#{difficulty_level}%", "%#{language}%")
                        if quest.empty?
                            render json:{
                                message: "No question found, check again the difficulty lavel and language."
                            }, status: :not_found
                        else
                            random_question_ids = quest.pluck(:id).sample(25)
                            random_questions = quest.where(id: random_question_ids)
                            render json:{
                                message: "These are questions based on your selected difficulty level and language.",
                                questions: random_questions.as_json(only: [:id, :ques], include: { options: { only: [:choice] } })
                            }, status: :ok
                        end
                    else
                        render json:{
                            message: "Only students allowed to see the question."
                        }, status: 401
                    end
                else
                    render json:{
                        message:"User must login to access the questions."
                    }, status: 401
                end
            end
        else
            render json: {
                message: "Invalid Token"
            }, status: 401
        end
    end
     

    # def submit_ans
    #     token = request.headers['token']&.split&.last
    #     if token
    #       payload = JWT.decode(token, nil, false).first
    #       if payload.present? && payload['exp'] >= Time.now.to_i
    #         current_user = User.find_by(id: payload['sub'])
    #         if current_user.login_status == true
    #           if current_user.role == "student"
    #             answer = params[:Answers]
    #             total_questions = answer.length
    #             correct_ans = 0
    
    #             answer.each do |answer|
    #               question = Question.find(answer[:question_id])
    #               users_choice = Option.find(answer[:choice]) if answer[:choice].present?
    #               if users_choice.present? && users_choice.choice == question.correct_answer
    #                 correct_ans += 1
    #               end
    #             end
    #             score = (correct_ans.to_f / total_questions.to_f) * 100
    #             score_percentage = "#{score} %"
    #             ResultMailer.result_email(current_user, score).deliver_now
    #             render json: {
    #               message: "Results sent on your Email-ID successfully!",
    #               score: score_percentage,
    #               correct_answer: correct_ans,
    #               total_questions: total_questions
    #             }
    #           else
    #             render json: {
    #               message: "Invalid user, permission denied."
    #             }
    #           end
    #         else
    #           render json: {
    #             message: "User must login to submit the answers."
    #           }, status: 401
    #         end
    #       end
    #     else
    #       render json: {
    #         message: "Invalid Token"
    #       }, status: 401
    #     end
    # end
    
    # def send_result_email
    #     token = request.headers['token']&.split&.last
    #     if token
    #       payload = JWT.decode(token, nil, false).first
    #       if payload.present? && payload['exp'] >= Time.now.to_i
    #         current_user = User.find_by(id: payload['sub'])
    #         score = params[:score].to_f 
    #         if score.present?
    #           ResultMailer.result_email(current_user, score).deliver_now
    #           render json: { message: "Result email sent successfully!" }
    #         else
    #           render json: { message: "Score is missing or invalid. Please provide a valid score." }, status: 400
    #         end
    #       end
    #     end
    # end

    def submit_ans
        token = request.headers['token']&.split&.last
        if token
          payload = JWT.decode(token, nil, false).first
          if payload.present? && payload['exp'] >= Time.now.to_i
            current_user = User.find_by(id: payload['sub'])
            if current_user.login_status == true
              if current_user.role == 'student'
                answer = params[:Answers]
                total_questions = answer.length
                correct_ans = 0
    
                answer.each do |answer|
                  question = Question.find(answer[:question_id])
                  users_choice = Option.find(answer[:choice]) if answer[:choice].present?
                  if users_choice.present? && users_choice.choice == question.correct_answer
                    correct_ans += 1
                  end
                end
                score = (correct_ans.to_f / total_questions.to_f) * 100
                score_percentage = "#{score} %"
    
                if valid_gmail_domain?(current_user.email)
                  ResultMailer.result_email(current_user, score).deliver_now
                  render json: {
                    message: "Results sent on your Email-ID successfully!",
                    score: score_percentage,
                    correct_answer: correct_ans,
                    total_questions: total_questions
                  }
                else
                  render json: {
                    message: "Invalid domain for your email address. Only Gmail addresses are allowed."
                  }, status: 422
                end
              else
                render json: {
                  message: "Invalid user, permission denied."
                }
              end
            else
              render json: {
                message: "User must login to submit the answers."
              }, status: 401
            end
          end
        else
          render json: {
            message: "Invalid Token"
          }, status: 401
        end
    end
    
    private
    
    def valid_gmail_domain?(email)
        domain = email.split('@').last
        domain == 'gmail.com'
    end

    def set_question
        question = Question.find_by(id: params[:id])
        if question
            return question
        end
    end

    def question_params
        params.require(:question).permit(:ques, :correct_answer, :difficulty_level, :language)
    end
end
    