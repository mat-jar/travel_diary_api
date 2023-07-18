require 'rails_helper'
include ActionController::RespondWith

RSpec.describe 'Whether access is ocurring properly', type: :request do

  before(:each) do
    @current_user = FactoryBot.create(:user)
    #@client = FactoryBot.create(:client)
  end

  context 'context: general authentication via API, ' do

    it 'gives you an authentication code if you are an existing user and you satisfy the password' do
      login
      #puts "#{response.headers.inspect}"
      #puts "#{response.body.inspect}"
      expect(JSON.parse(response.body)["headers"]["access-token"]).not_to be_nil
      expect(JSON.parse(response.body)["headers"]["client"]).not_to be_nil
      expect(JSON.parse(response.body)["headers"]["uid"]).not_to be_nil

    end


  end


  def login
    post api_v1_social_auth_callback_path, params:  { email: @current_user.email, provider: @current_user.provider, uid: @current_user.uid }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def get_auth_params_from_login_response_headers(response)
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']
​
    auth_params = {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token-type' => token_type
    }
    auth_params
  end

end
