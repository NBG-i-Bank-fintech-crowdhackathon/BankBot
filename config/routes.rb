Rails.application.routes.draw do
  resources :messages
  resources :users
  root to: 'visitors#index'
  get 'webhook', to: 'messages#webhook'
  post 'webhook', to: 'messages#handle_message' 

end
