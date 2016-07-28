Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  get "/managed_projects" => "projects#managed_projects"
  get "/contributed_projects" => "projects#contributed_projects"

  resources :notifications, only: [:index] do
    member do
      put "mark_as_read"
    end
  end

  authenticated :user do
    root "users#dashboard"
  end

  get "/users/search" => "users#search"

  resources :projects do
    post "/create" => "user_projects#create"
    delete "/destroy" => "user_projects#destroy"
    get "/participants" => "user_projects#participants"
    member do
      get "link_contributors"
    end
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
