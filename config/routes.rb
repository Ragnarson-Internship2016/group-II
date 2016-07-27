Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  get "/managed_projects" => "projects#managed_projects"
  get "/contributed_projects" => "projects#contributed_projects"

  authenticated :user do
    root "users#dashboard"
  end

  resources :projects do
    collection do
      get "managed"
      get "contributed"
    end
    resources :tasks
    post "/tasks/:id/assign" => "user_tasks#assign"
    delete "/tasks/:id/leave" => "user_tasks#leave"
    put "/tasks/:id/done" => "tasks#mark_as_done"
    resources :events
  end

  root "home#index"
end
