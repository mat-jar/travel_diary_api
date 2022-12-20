require 'rails_helper'

RSpec.describe 'Entries', type: :request do
  describe 'GET /show' do

    context 'with user and their entry' do
    include_context "sign_in_user"

      let!(:new_entry) { FactoryBot.create(:entry, user_id: new_user.id) }

      before do

        auth_headers = {
          "access-token" => JSON.parse(response.body)["headers"]["access-token"],
          "client" => JSON.parse(response.body)["headers"]["client"],
          "uid" => JSON.parse(response.body)["headers"]["uid"]
        }
        get "/api/v1/entries/#{new_entry.id}", headers: auth_headers
      end

      it 'returns the title' do
        expect(JSON.parse(response.body)['title']).to eq(new_entry.title)
      end

      it 'returns the note' do
        expect(JSON.parse(response.body)['note']).to eq(new_entry.note)
      end

      it 'returns the place' do
        expect(JSON.parse(response.body)['place']).to eq(new_entry.place)
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

      context 'without logged user' do

        let!(:new_user) { FactoryBot.create(:user) }
        let!(:new_entry) { FactoryBot.create(:entry, user_id: new_user.id) }

        before do

          auth_headers = {
            "access-token" => "",
            "client" => "",
            "uid" => ""
          }

          get "/api/v1/entries/#{new_entry.id}", headers: auth_headers
        end
        it 'returns a demand to log in or sign up' do
          expect(JSON.parse(response.body)["errors"][0]).to eq("You need to sign in or sign up before continuing.")
        end
        it 'returns an unauthorized status' do
          expect(response).to have_http_status(:unauthorized)
        end
    end
  end
end
