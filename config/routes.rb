require 'sidekiq/web'

Rails.application.routes.draw do
  root 'tokens#index'
  resources :tokens

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
end
