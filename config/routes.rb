Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  get 'users/setup', to: 'users#setup'

  get 'users/home', to: 'pets#home'

  get 'users/home/check_time_stamps', to: 'pets#check_time_stamps'

  get 'users/home/feed', to: 'pets#inc_hunger'

  get 'users/home/sleep', to: 'pets#inc_sleep'

  get 'users/home/attention', to: 'pets#inc_attention'

  resources :users, only: [:new, :create, :update]

  resources :pets, only: [:new, :create]

  resources :session
end
