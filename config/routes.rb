Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"

  mount GoodJob::Engine => 'good_job'

  resources :github_releases, only: %i[index]
end
