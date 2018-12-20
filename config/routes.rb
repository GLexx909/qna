Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    resources :answers do
      patch :mark_best, on: :member
    end

    delete :delete_file, on: :member
  end

  root 'questions#index'
end
