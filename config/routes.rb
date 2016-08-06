Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  get 'users/setup', to: 'users#setup'

  resources :users, only: [:new, :create]

  resources :session

  resources :user
end
