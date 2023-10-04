Rails.application.routes.draw do
  # Defines the root path route ("/")
  # root "articles#index"

  mount GoodJob::Engine => "good_job"

  namespace :github do
    resources :repositories, only: %i[] do
      resources :releases, only: %i[] do
        resources :reactions, only: %i[create destroy]
      end
    end

    resources :releases, only: %i[index]
  end
end
