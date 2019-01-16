Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  resources :questions, concerns: [:votable], shallow: true do
    resources :answers, concerns: [:votable] do
      patch :mark_best, on: :member
      delete :delete_file, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  namespace :my do
    resources :badges, only: :index
  end

end
