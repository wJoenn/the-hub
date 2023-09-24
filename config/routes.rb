Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"

  resources :github_releases, only: %i[index]
end
