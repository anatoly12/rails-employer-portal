Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/check", to: "application#check"
  namespace :admin do
    resource :sessions, path: "/sign-in", only: [:show, :create, :destroy]
    resources :plans
    resources :companies do
      resource :theme, only: [:show, :update, :destroy]
    end
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
  resources :reset_passwords, only: [:index, :new, :create, :show, :edit, :update]
  resources :employees do
    get "bulk_import", on: :collection
    delete "delete_all", on: :collection
    patch "reactivate", on: :member
    patch "contact", on: :member
    patch "send_reminder", on: :member
    get "health_passport", on: :member
    resources :symptom_logs, only: :show
  end
  resources :companies, only: [] do
    get "overrides", on: :member
  end
  resources :plans, only: [:index]
  root to: "employees#index"
end
