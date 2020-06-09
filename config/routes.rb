Rails.application.routes.draw do
  get '/', to: 'welcome#index'
  resource :sessions, path: "/sign-in", only: [:show, :create, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
