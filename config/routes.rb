# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#root'

  resources :organizations, only: %i[index show create] do
    member do
      get 'users' => 'organizations#users'
      post 'users' => 'organizations#add_user'
    end

    # employee attendance
    post 'attendances/check_in' => 'organizations#check_in'
    post 'attendances/check_out' => 'organizations#check_out'
    # admin attendance
    get 'attendances/:user_id' => 'organizations#user_attendances'
    post 'attendances/:user_id/check_in' => 'organizations#user_check_in'
    post 'attendances/:user_id/check_out' => 'organizations#user_check_out'
  end

  get 'users/me' => 'users#me'
  post 'users' => 'users#create'
  post 'login' => 'user_token#create'
end
