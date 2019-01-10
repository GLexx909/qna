Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions, shallow: true do
    resources :answers do
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
