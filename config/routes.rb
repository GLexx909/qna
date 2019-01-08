Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions, shallow: true do
    resources :answers do
      patch :mark_best, on: :member
      delete :delete_file, on: :member
    end
  end

  delete "destroy_file/:id", to: "attachments#destroy", as: "destroy_file"
  delete "destroy_link/:id", to: "links#destroy", as: "destroy_link"

  namespace :my do
    get 'badges', to: 'badges#index'
  end

end
