class Api::V1::EntriesController < ApplicationController
  before_action :set_entry, only: %i[ show edit update destroy ]
  #before_action :authenticate_user!

  def index
    @entries = Entry.all
    render json: @entries, status: :ok
  end

  def show
    render json: @entry, status: :ok
  end

  def create
    @entry = Entry.new(entry_params)

    if @entry.save
      render json: @entry, status: :ok
    else
      render json: @entry.errors, status: :unprocessable_entity
    end

  end

  def update
    if @entry.update(entry_params)
      render json: @entry, status: :ok
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @entry.destroy
    render json: { notice: 'Entry was successfully removed.' }
    head :no_content, status: :ok
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
    @weather = GetWeatherFromPlace.call(weather_params[:place])
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
      params.require(:entry).permit(:title, :place, :note, :weather)
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
end
