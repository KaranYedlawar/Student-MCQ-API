class QuestionsController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def index
        quesion = Question.all
        if quesion.empty?
            render json:{
                message: "No quesion found",
                quesion: []
            }, status: :not_found
        else
            render json:{
                message: "All quesions..",
                quesion: quesion
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
                            render json:{
                                message: "These are questions based on your selected difficulty level and language.",
                                questions: quest.as_json(only: [:id, :ques], include: { options: { only: [:id,:choice] } })
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


    def submit_ans
        token = request.headers['token']&.split&.last
        if token
            payload= JWT.decode(token, nil, false).first
            if payload.present? && payload['exp'] >= Time.now.to_i
                current_user = User.find_by(id: payload['sub'])
                if current_user.login_status == true
                    if current_user.role == "student"
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
                        score = (correct_ans.to_f/ total_questions.to_f) * 100
                        render json:{
                            message: "Your Marks",
                            score:score,
                            correct_answer:correct_ans,
                            total_questions:total_questions
                        }
                    else
                        render json:{
                            message: "Invalid user, permission denied."
                        }
                    end
                else
                    render json: {
                        message:"User must login to submit the answers."
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
