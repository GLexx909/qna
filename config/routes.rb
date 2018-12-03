Rails.application.routes.draw do
  devise_for :users


  resources :questions, shallow: true do
    resources :answers
  end
  root 'questions#index'
end
