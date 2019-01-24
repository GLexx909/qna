Rails.application.routes.draw do
  devise_for :users
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

  mount ActionCable.server => '/cable'
end
