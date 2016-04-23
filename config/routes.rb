Rails.application.routes.draw do
  resources :messages
  resources :users
  root to: 'visitors#index'
  get 'webhook', to: 'messages#webhook'
  post 'webhook', to: 'messages#handle_message'

  get 'auth', to: 'users#authenticate' 
  get 'auth', to: 'users#select_pin' 
end
