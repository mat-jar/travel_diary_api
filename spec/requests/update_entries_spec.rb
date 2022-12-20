require 'rails_helper'

RSpec.describe 'Entries', type: :request do
  describe 'PUT /update' do

    context 'with valid parameters' do
    include_context "sign_in_user"
    let!(:new_entry) { FactoryBot.create(:entry, user_id: new_user.id) }

      before do

        auth_headers = {
          "access-token" => JSON.parse(response.body)["headers"]["access-token"],
          "client" => JSON.parse(response.body)["headers"]["client"],
          "uid" => JSON.parse(response.body)["headers"]["uid"]
        }

        put "/api/v1/entries/#{new_entry.id}", params:
                          { entry: {
                            title: "Updated title",
                            note: "Updated note",
                            place: "Updated place",
                            weather: "Updated weather"
                          } }, headers: auth_headers
      end

      it 'returns the updated title' do
        expect(JSON.parse(response.body)['title']).to eq("Updated title")
      end

      it 'returns the updated note' do
        expect(JSON.parse(response.body)['note']).to eq("Updated note")
      end

      it 'returns the updated place' do
        expect(JSON.parse(response.body)['place']).to eq("Updated place")
      end

      it 'returns the updated weather' do
        expect(JSON.parse(response.body)['weather']).to eq("Updated weather")
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
    include_context "sign_in_user"
    let!(:new_entry) { FactoryBot.create(:entry, user_id: new_user.id) }

      before do

        auth_headers = {
          "access-token" => JSON.parse(response.body)["headers"]["access-token"],
          "client" => JSON.parse(response.body)["headers"]["client"],
          "uid" => JSON.parse(response.body)["headers"]["uid"]
        }

        put "/api/v1/entries/#{new_entry.id}", params:
                          { entry: {
                            title: "",
                            note: "",
                            place: "",
                            weather: ""
                          } }, headers: auth_headers
        end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
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

            put "/api/v1/entries/#{new_entry.id}", params:
                              { entry: {
                                title: "Updated title",
                                note: "Updated note",
                                place: "Updated place",
                                weather: "Updated weather"
                              } }
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
