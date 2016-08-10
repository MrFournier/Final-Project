Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  get 'users/setup', to: 'users#setup'

  get 'users/home', to: 'users#home'

  resources :users, only: [:new, :create, :update]

  resources :pets, only: [:new, :create]

  resources :session
end
