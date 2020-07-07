Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/check", to: "application#check"
  namespace :admin do
    resource :sessions, path: "/sign-in", only: [:show, :create, :destroy]
    resources :plans
    resources :companies
    resources :employers
    resources :employees, only: [:index] do
      patch "retry", on: :member
    end
    resources :email_templates
    resources :email_logs, only: [:index, :show]
    resources :users
    root to: "dashboard#index"
  end
  resource :sessions, path: "/sign-in", only: [:show, :create, :destroy]
  resources :employees do
    get "bulk_import", on: :collection
    delete "delete_all", on: :collection
    get "health_passport", on: :member
    patch "contact", on: :member
    patch "send_reminder", on: :member
    patch "reactivate", on: :member
    resources :symptom_logs, only: :show
  end
  resources :plans, only: [:index]
  root to: "employees#index"
end
