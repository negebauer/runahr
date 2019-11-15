# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#root'

  resources :organizations, only: %i[index show create update] do
    resources :organization_users, path: 'users', param: 'user_id' do
      member do
        get 'attendances' => 'attendances#user_attendances'
        post 'attendances/check_in' => 'attendances#user_check_in'
        post 'attendances/check_out' => 'attendances#user_check_out'
      end
    end

    get 'attendances/me'
    post 'attendances/check_in'
    post 'attendances/check_out'

    resources :attendances
  end

  get 'users/me' => 'users#me'
  post 'users' => 'users#create'
  post 'login' => 'user_token#create'
end
