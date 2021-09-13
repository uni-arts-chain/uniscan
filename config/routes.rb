require 'sidekiq/web'

Rails.application.routes.draw do
  resources :tokens, only: [:index, :show]
  resources :collections, only: [:show]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
end
