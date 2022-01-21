require 'sidekiq/web'

Rails.application.routes.draw do
  root 'tokens#index'
  get 'welcome/index'

  get 'tokens/:address/:token_id/update_metadata', to: 'tokens#update_metadata'
  resources :tokens, only: [:index, :show]
  resources :collections, only: [:show]
  resources :accounts, only: [:show]

  get 'contracts/:address', to: 'collections#show2'
  get 'tokens/:address/:token_id', to: 'tokens#show2'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
end
