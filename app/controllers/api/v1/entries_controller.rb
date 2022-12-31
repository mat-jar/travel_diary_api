class Api::V1::EntriesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :set_entry, only: %i[ show edit update destroy ]
  before_action :authenticate_user!



  def index
    @entries = Entry.where(user_id: current_user.id)
    render json: @entries, status: :ok
  end

  def search
    #@search_phrase = search_params[:search_phrase]
    @entries = Entry.where(user_id: current_user.id)
    @entries = SearchEntries.call(@entries, search_params)
    render json: @entries, status: :ok
  end

  def show
    if @entry.user != current_user
      render json: { message: "Not authorized to see this entry"}, status: :forbidden
    else
      render json: @entry, status: :ok
    end
  end

  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user
    @entry.weather = get_weather_from_api(entry_params[:place])

    if @entry.save
      render json: @entry, status: :ok
    else
      render json: @entry.errors, status: :unprocessable_entity
    end

  end

  def update

    if @entry.user != current_user
      render json: { message: "Not authorized to edit this entry"}, status: :forbidden
    end

    if @entry.update(entry_params)
      render json: @entry, status: :ok
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  def destroy

    if @entry.user != current_user
      render json: { message: "Not authorized to delete this entry"}, status: :forbidden
    else
      @entry.destroy
      render json: { notice: 'Entry was successfully removed.' }
      head :no_content, status: :ok
    end
  end

  def get_coordinates
    @coordinates = GetCoordinatesFromPlace.call(coordinates_params[:place])
    render json: @coordinates, status: :ok
  end

  def get_weather_from_coordinates
    @weather = GetWeatherFromCoordinates.call({latitude: weather_params[:latitude], longitude: weather_params[:longitude]})
    render json: @weather, status: :ok
  end

  def get_weather
    @weather = get_weather_from_api(weather_params[:place])
    render json: @weather, status: :ok
  end

  private

    def set_entry
      if params[:id]
        @entry = Entry.find(params[:id])
        render status: :not_found if id_with_wrong_title?
      end
    end

    def entry_params
      params.fetch(:entry, {}).permit(:title, :place, :note, :weather)
      #accept weather param to enable user to change fetched weather on update
    end

    def search_params
      params.require(:search).permit(:search_phrase)
    end

    def coordinates_params
      params.require(:coordinates).permit(:place)
    end

    def weather_params
      params.require(:weather).permit(:place)
    end

    def weather_from_coordinates_params
      params.require(:weather).permit(:latitude, :longitude)
    end

    def id_with_wrong_title?
      (params[:id].sub(@entry.id.to_s, '') != '') &&
      (@entry.slug != params[:id])
    end

    def get_weather_from_api(place)
      formatted_place = place.gsub(/\s+/, "")
      weather = GetWeatherFromPlace.call(formatted_place)
      return weather
    end
end
