Rails.application.routes.draw do
  resources :entries

  devise_for :users,
      controllers: {
         omniauth_callbacks: 'users/omniauth_callbacks'
      }


  post '/auth/:provider/callback' => 'sessions#omniauth'

  root "entries#index"
end
