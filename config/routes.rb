# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#root'

  resources :organizations, only: %i[index show create] do
    member do
      post 'users' => 'organizations#add_user'
    end
  end

  get 'users/me' => 'users#me'
  post 'users' => 'users#create'
  post 'login' => 'user_token#create'
end
