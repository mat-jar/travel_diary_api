RSpec.shared_context "sign_in_user", :shared_context => :metadata do
    let!(:new_user) { FactoryBot.create(:user)}

    before do

      post '/api/v1/social_auth/callback', params:
                        {
                          email: new_user.email,
                          uid: new_user.uid,
                          provider: new_user.provider
                        }

      end
end
