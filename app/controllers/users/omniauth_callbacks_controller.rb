class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
   def google_oauth2
     user = User.from_omniauth(from_google_params)

     if user.present?
       sign_out_all_scopes
       flash[:notice] = t 'devise.omniauth_callbacks.success', kind: 'Google'
       sign_in_and_redirect user, event: :authentication
     else
       flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
       redirect_to new_user_session_path
     end
    end

    def from_google_params
      @from_google_params ||= {
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email
      }
    end

    def auth
      @auth ||= request.env['omniauth.auth']
    end
end

=begin
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
        redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      end
  end
end
=end
