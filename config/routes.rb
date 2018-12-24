Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    resources :answers do
      patch :mark_best, on: :member
      delete :delete_file, on: :member
    end
  end

  delete "destroy_file/:id", to: "attachments#destroy", as: "destroy_file"

  root 'questions#index'
end
