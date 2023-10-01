Rails.application.routes.draw do
   require 'sidekiq/web'
   mount Sidekiq::Web, at:'/sidekiq'

  devise_for :users

  devise_scope :user do
    get 'login', to: 'users/sessions#new'
  end

  devise_scope :user do
    get 'signup', to: 'users/registrations#new'
  end

  # devise_for :users, controllers: {
  #   sessions: 'users/sessions'
  # }


  resources :reminders
  root to: 'reminders#index'

  # match '*path', :to => 'application#routing_error', :via => :all
end
