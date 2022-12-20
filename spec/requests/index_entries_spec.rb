require 'rails_helper'


RSpec.describe 'Entries', type: :request do
  describe 'GET /index' do

    context 'with user and their entries' do
      include_context "sign_in_user"

      let!(:new_entry) { FactoryBot.create(:entry, user_id: new_user.id) }

      before do
        auth_headers = {
          "access-token" => JSON.parse(response.body)["headers"]["access-token"],
          "client" => JSON.parse(response.body)["headers"]["client"],
          "uid" => JSON.parse(response.body)["headers"]["uid"]
        }
        get '/api/v1/entries', headers: auth_headers

      end

      it 'returns entry' do

        expect(JSON.parse(response.body)[0]).to eq(JSON.parse(new_entry.to_json))

      end
    end

    context 'with user and not their entry' do
      include_context "sign_in_user"

      let!(:new_user2) { FactoryBot.create(:user) }
      let!(:new_entry) { FactoryBot.create(:entry, user_id: new_user2.id) }

      before do
        auth_headers = {
          "access-token" => JSON.parse(response.body)["headers"]["access-token"],
          "client" => JSON.parse(response.body)["headers"]["client"],
          "uid" => JSON.parse(response.body)["headers"]["uid"]
        }

        get '/api/v1/entries', headers: auth_headers

      end
      it 'returns empty array' do
        expect(response.body).to eq("[]")
      end

    end



  end
end
