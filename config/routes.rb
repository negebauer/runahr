# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#root'

  post 'users' => 'users#create'
  post 'user_token' => 'user_token#create'
end
