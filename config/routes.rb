Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for:users, controllers: {
    sessions:'users/sessions', 
    registrations: 'users/registrations'
  }

  resources :users, only: [:create]
  resources :questions, only: [:index, :create, :update]


  post 'verifyotp', to:'accounts#sms_confirm' 

  get 'users', to: 'users#index'
  get 'showUser', to: 'users#show'
  delete "deleteUser/:id", to: "users#destroy"

  get 'interests', to: 'interests#index'
  post 'createinterests', to: 'interests#create'

  get 'qualifications', to: 'qualifications#index'
  post 'createqualifications', to: 'qualifications#create'

  get 'academics', to: 'academics#index'
  post 'createacademics', to: 'academics#create'

  get 'getallquestion', to: 'questions#index'
  get 'getquestion', to: 'questions#condition_based_question'
  post 'createquestion', to: 'questions#create'
  post 'submitanswer', to: 'questions#submit_ans'

  get 'getoption', to: 'options#index'
  post 'createoption', to: 'options#create'

end
