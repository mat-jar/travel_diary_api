Rails.application.routes.draw do
  resources :entries

  devise_for :users,
      controllers: {
         omniauth_callbacks: 'users/omniauth_callbacks'
      }

  namespace :api, defaults: {format: 'json'} do
      namespace :v1 do
        mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
        post 'social_auth/callback', to: 'social_auth#authenticate_social_auth_user'
        resources :entries
        resources :entries do
          post 'get_weather', on: :collection
          post 'get_coordinates', on: :collection
          post 'get_weather_from_coordinates', on: :collection
        end
      end
  end

  post '/auth/:provider/callback' => 'sessions#omniauth'

  root "entries#index"
end
