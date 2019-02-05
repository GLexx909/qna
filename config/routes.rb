Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, concerns: [:votable], shallow: true do
    resources :comments, only: [:create, :destroy]

    resources :answers, concerns: [:votable] do
      resources :comments, only: [:create, :destroy]
      patch :mark_best, on: :member
      delete :delete_file, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  namespace :my do
    resources :badges, only: :index
  end

  resources :preregistrations, only: [:new, :create]

  # API

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: [:index]
    end
  end

  mount ActionCable.server => '/cable'
end
