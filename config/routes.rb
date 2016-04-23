Rails.application.routes.draw do
  resources :messages
  resources :users
  root to: 'visitors#index'
  get 'webhook', to: 'messages#webhook'
  post 'webhook', to: 'messages#handle_message'

  get 'auth', to: 'users#authenticate' 
  get 'select_pin', to: 'users#select_pin' 
  post 'select_pin', to: 'users#select_pin' 
  post 'set_pin', to: 'users#set_pin' 
end
