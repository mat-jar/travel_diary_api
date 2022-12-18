class User < ApplicationRecord

  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]


         def self.from_omniauth(params)
           find_or_create_by(provider: params[:provider], uid: params[:uid]) do |user|
               user.email = params[:email]
               user.password = Devise.friendly_token[0, 20]
               user.confirm
           end
         end
end
