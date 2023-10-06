Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"

  mount GoodJob::Engine => "good_job"

  concern :reactable do
    resources :reactions, only: %i[create destroy]
  end

  namespace :github do
    resources :repositories, only: %i[] do
      resources :releases, only: %i[], concerns: :reactable
    end

    resources :releases, only: %i[index]
  end
end
