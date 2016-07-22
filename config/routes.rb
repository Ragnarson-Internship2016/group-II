Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  root 'home#index'

  resources :projects do
    resources :tasks

      post "/tasks/:id/assign" => "user_tasks#assign"
      delete "/tasks/:id/leave" => "user_tasks#leave"
  end
end
