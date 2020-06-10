Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :sessions, path: "/sign-in", only: [:show, :create, :destroy]
  resources :employees
  root to: "employees#index"
end
