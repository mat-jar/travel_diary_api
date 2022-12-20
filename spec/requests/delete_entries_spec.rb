require 'rails_helper'

RSpec.describe 'Entries', type: :request do
  describe "DELETE /destroy" do
    context 'with user and their entry' do
    include_context "sign_in_user"
    let!(:new_entry) { FactoryBot.create(:entry, user_id: new_user.id) }

      before do

        auth_headers = {
          "access-token" => JSON.parse(response.body)["headers"]["access-token"],
          "client" => JSON.parse(response.body)["headers"]["client"],
          "uid" => JSON.parse(response.body)["headers"]["uid"]
        }

        delete "/api/v1/entries/#{new_entry.id}", headers: auth_headers
      end

      it 'returns status no_content - code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with user and not their entry' do
    include_context "sign_in_user"
    let!(:new_user2) { FactoryBot.create(:user)}
    let!(:new_entry) { FactoryBot.create(:entry, user_id: new_user2.id) }

      before do

        auth_headers = {
          "access-token" => JSON.parse(response.body)["headers"]["access-token"],
          "client" => JSON.parse(response.body)["headers"]["client"],
          "uid" => JSON.parse(response.body)["headers"]["uid"]
        }

        delete "/api/v1/entries/#{new_entry.id}", headers: auth_headers
      end

      it 'returns status forbidden - code 403' do
        expect(response).to have_http_status(:forbidden)
      end
    end

  end
end
