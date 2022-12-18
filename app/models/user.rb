class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]


         def self.from_omniauth(params)
           find_or_create_by(provider: params[:provider], uid: params[:uid]) do |user|
               user.email = params[:email]
               user.password = Devise.friendly_token[0, 20]
           end
         end
end
