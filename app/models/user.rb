class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  include DeviseTokenAuth::Concerns::User

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :entries


         def self.from_omniauth(params)
           find_or_create_by(provider: params[:provider], uid: params[:uid]) do |user|
               user.email = params[:email]
               user.password = Devise.friendly_token[0, 20]
           end
         end
end
