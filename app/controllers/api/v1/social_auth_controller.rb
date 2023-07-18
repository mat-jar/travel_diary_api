require 'json'
require 'googleauth'

class Api::V1::SocialAuthController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  def authenticate_social_auth_user
    #  params is the response I receive from the client with the data from the provider about the user
    data = Google::Auth::IDTokens.verify_oidc params[:access_token], aud: ENV["GOOGLE_CLIENT_ID"]
    debugger
    @user = User.from_omniauth(params) # this method add a user who is new or logins an old one
    if @user.persisted?
      # I log the user in at this point
      sign_in(@user)
      # after user is loggedIn, I generate a new_token here
      login_token = @user.create_new_auth_token
      render json: {
        status: 'SUCCESS',
        message: "user was successfully logged in through #{params[:provider]}",
        headers: login_token
      },
             status: :created
    else
      render json: {
        status: 'FAILURE',
        message: "There was a problem signing you in through #{params[:provider]}",
        data: @user.errors
      },
             status: :unprocessable_entity
    end
  end
end
