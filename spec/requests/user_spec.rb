require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::IntegrationHelpers
  include Devise::Test::ControllerHelpers
  include FactoryBot::Syntax::Methods

  describe 'GET #index' do
    context 'when there are users in the database' do
      it 'returns a list of all existing users' do
        user1 = create(:user)
        user2 = create(:user)

        get :index

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('All existing users')
        expect(JSON.parse(response.body)['users'].length).to eq(2)
      end
    end

    context 'when there are no users in the database' do
      it 'returns a "Not Found" message' do
        get :index

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('No users found')
        expect(JSON.parse(response.body)['users']).to be_empty
      end
    end
  end


  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user' do  
        expect {
          post :create, params: { user: { first_name: "vikas Doe", email: "johnn@example.com", password: "password", role: "student", full_phone_number: '+918698586828', gender: 'male' } }
        }.to change(User, :count).by(1)
  
        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(JSON.parse(response.body)['message']).to eq('User profile created successfully')
      end
    end
  
  
    context 'with invalid parameters' do
      it 'returns an "Unprocessable Entity" status and error message' do
  
        post :create, params: { user: {email: nil}}
  
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Unable to create user, check details again!')
        expect(JSON.parse(response.body)['errors']).to include("Email can't be blank")
      end
    end
  end  

  describe 'GET #show' do
    context 'when user with id exists' do
      let(:user) { create(:user) }

      before { get :show, params: { id: user.id } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct user data' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('User found')
        expect(parsed_response['user']['id']).to eq(user.id)
      end
    end

    context 'when user does not exist' do
      before { get :show, params: { id: 9999 } } 

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a "User not found" message' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('User not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user exists' do
      let!(:user) { create(:user) } 

      it 'destroys the user' do
        expect {
          delete :destroy, params: { id: user.id }
        }.to change(User, :count).by(-1)
      end

      it 'returns a successful response' do
        delete :destroy, params: { id: user.id }
        expect(response).to have_http_status(:ok)
      end

      it 'returns the destroyed user data' do
        delete :destroy, params: { id: user.id }
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('User deleted successfully')
        expect(parsed_response['user']['id']).to eq(user.id)
      end
    end

    context 'when user does not exist' do
      before { delete :destroy, params: { id: 9999 } } 

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns a "User not found to delete" message' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('User not found to delete')
      end
    end
  end
end