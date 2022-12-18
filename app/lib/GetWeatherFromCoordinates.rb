require "httparty"

class GetWeatherFromCoordinates < ApplicationService
  def call
    get_weather
  end

  private

  attr_reader :coordinates, :options

  def initialize(coordinates, options = nil)
    @coordinates = coordinates
    @options = options
    @api_key = ENV["OPEN_WEATHER_API_KEY"]
  end

  def get_weather
    url = "http://api.openweathermap.org/data/2.5/weather?lat=#{@coordinates[:latitude]}&lon=#{@coordinates[:longitude]}&appid=#{@api_key}"

    response = HTTParty.get(url)
    @weather = response["weather"][0]["description"]
    return @weather
  end
end
