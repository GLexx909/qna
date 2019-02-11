require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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
    # resources :subscriptions, only: :swap

    resources :answers, concerns: [:votable] do
      resources :comments, only: [:create, :destroy]
      patch :mark_best, on: :member
      delete :delete_file, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  post 'subscribe/:id', to: 'subscriptions#swap', as: :subscribe

  namespace :my do
    resources :badges, only: :index
  end

  resources :preregistrations, only: [:new, :create]

  # API

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy], shallow: true do
        resources :answers, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
