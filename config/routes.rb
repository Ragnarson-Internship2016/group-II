Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  root "home#index"

  resources :projects do
    resources :tasks
    post "/tasks/:id/assign" => "user_tasks#assign"
    delete "/tasks/:id/leave" => "user_tasks#leave"
    # collection do
    #
    # end
    # member do
    #   get "/tasks" => "tasks#project_assigned"
    #
    #   put "/tasks/:id/done" => "tasks#mark_as_done"
    # end
  end
end
