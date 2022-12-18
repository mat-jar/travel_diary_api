require "httparty"

class GetCoordinatesFromPlace < ApplicationService
  def call
    get_coordinates
  end

  private

  attr_reader :place, :options

  def initialize(place, options = nil)
    @place = place
    @options = options
    @api_key = ENV["OPEN_WEATHER_API_KEY"]
  end

  def get_coordinates
    url = "http://api.openweathermap.org/geo/1.0/direct?q=#{@place}&appid=#{@api_key}"
    response = HTTParty.get(url)
    parsed_body = JSON.parse(response.body)[0]
    @coordinates = {latitude: parsed_body["lat"], longitude: parsed_body["lon"]}
    return @coordinates
  end

end
