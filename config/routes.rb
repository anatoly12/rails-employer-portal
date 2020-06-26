Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/check", to: "application#check"
  resource :sessions, path: "/sign-in", only: [:show, :create, :destroy]
  resources :employees do
    get "bulk_import", on: :collection
    delete "delete_all", on: :collection
    resources :symptom_logs, only: :show
  end
  root to: "employees#index"
end
