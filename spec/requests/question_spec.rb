require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods

  let(:admin_user) { FactoryBot.create(:user, role: 'admin') }
  let(:student_user) { FactoryBot.create(:user, role: 'student', login_status: true) }
  let(:academic) { FactoryBot.create(:academic, user: user) }


  describe 'GET #index' do
    context 'when there are questions in the database' do
      it 'returns the paginated questions data' do
        question1 = create(:question)
        question1 = create(:question)
        get :index
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('All questions..')
        expect(parsed_response['current_page']).to eq(1)
        expect(parsed_response['total_pages']).to eq(1)
        expect(parsed_response['questions'].length).to eq(2)
      end

      it 'returns not_found when no questions are available' do
        get :index
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('No question found')
      end
    end
  end

  describe 'POST #create' do
    context 'as an admin user' do
      before { sign_in(admin_user) }

      it 'creates a new question' do
        question_params = FactoryBot.attributes_for(:question)
        expect {
          post :create, params: { question: question_params }
        }.to change(Question, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('question')
      end

      it 'returns an error when unable to create a question' do
        question_params = FactoryBot.attributes_for(:question, ques: '')
        expect {
          post :create, params: { question: question_params }
        }.not_to change(Question, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end

    context 'as a non-admin user' do
      before { sign_in(student_user) }
    
      it 'does not create a new question' do
        question_params = FactoryBot.attributes_for(:question)
        expect {
          post :create, params: { question: question_params }
        }.not_to change(Question, :count)
    
        expect(response).to have_http_status(:unauthorized) 
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('Only admin can create a question!') 
      end
    end
  end

  describe 'PUT #update' do
    context 'as an admin user' do
      before { sign_in(admin_user) }

      it 'updates an existing question' do
        question = create(:question)
        updated_ques = 'What is Ruby on Rails?'
        put :update, params: { id: question.id, question: { ques: updated_ques } }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Question Updated Successfully')
        expect(JSON.parse(response.body)['question']['ques']).to eq(updated_ques)
      end

      it 'returns an error when unable to update a question' do
        question = create(:question)
        put :update, params: { id: question.id, question: { ques: '' } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end
end
