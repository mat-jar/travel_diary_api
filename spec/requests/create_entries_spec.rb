require 'rails_helper'

RSpec.describe 'Entries', type: :request do
  describe 'POST /create' do

    context 'with valid parameters (with weather)' do
    include_context "sign_in_user"
    let!(:new_entry) { FactoryBot.build(:entry) }

      before do

        new_entry.place = "Warsaw"

        auth_headers = {
          "access-token" => JSON.parse(response.body)["headers"]["access-token"],
          "client" => JSON.parse(response.body)["headers"]["client"],
          "uid" => JSON.parse(response.body)["headers"]["uid"]
        }

        params = { entry:
                    {
                			title: new_entry.title,
                			note: new_entry.note,
                      place: new_entry.place
                		}
                	}

        post '/api/v1/entries', params: params, headers: auth_headers
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

      it 'returns a created status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
    include_context "sign_in_user"
      before do

        auth_headers = {
          "access-token" => JSON.parse(response.body)["headers"]["access-token"],
          "client" => JSON.parse(response.body)["headers"]["client"],
          "uid" => JSON.parse(response.body)["headers"]["uid"]
        }

        params = { entry:
                    {
                			title: "",
                			note: "",
                      place: ""
                		}
                	}

        post '/api/v1/entries', params: params, headers: auth_headers

      end
      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

      context 'without logged user' do

        let!(:new_entry) { FactoryBot.build(:entry) }

        before do

          auth_headers = {
            "access-token" => "",
            "client" => "",
            "uid" => ""
          }

          params = { entry:
                      {
                  			title: new_entry.title,
                  			note: new_entry.note,
                        place: new_entry.place
                  		}
                  	}

          post '/api/v1/entries', params: params, headers: auth_headers
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
