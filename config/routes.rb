Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for:users, controllers: {
    sessions:'users/sessions', 
    registrations: 'users/registrations'
  }

  post 'verifyotp', to:'accounts#sms_confirm'

  # post "createprofile", to: "users#create"
  get 'users', to: 'users#index'
  # delete "deleteprofile", to: "users#destroy"

  get 'interests', to: 'interests#index'
  post 'createinterests', to: 'interests#create'

  get 'qualifications', to: 'qualifications#index'
  post 'createqualifications', to: 'qualifications#create'

  get 'academics', to: 'academics#index'
  post 'createacademics', to: 'academics#create'

  get 'getquestion', to: 'questions#condition_based_question'
  post 'createquestion', to: 'questions#create'
  post 'submitanswer', to: 'questions#submit_ans'

  get 'getoption', to: 'options#index'
  post 'createoption', to: 'options#create'

end
