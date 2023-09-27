Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"

  mount GoodJob::Engine => 'good_job'

  resources :github_repositories, only: %i[] do
    resources :github_releases, only: %i[] do
      resources :github_reactions, only: %i[create destroy]
    end
  end

  resources :github_releases, only: %i[index]
end
