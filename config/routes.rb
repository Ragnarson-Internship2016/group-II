Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root 'home#index'

  resources :projects do
    collection do

    end
    member do
      get '/tasks => 'tasks#project_assigned'
      post "/tasks/:id/assign" => "user_tasks#assign"
      delete "/tasks/:id/leave" => "user_tasks#leave"
    end
  end
end
