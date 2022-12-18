require "httparty"

class GetWeatherFromPlace < ApplicationService
  def call
    get_weather
  end

  private

  attr_reader :place, :options

  def initialize(place, options = nil)
    @place = place
    @options = options
    @api_key = ENV["VISUAL_CROSSING_API_KEY"]
  end

  def get_weather
    url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{@place}/today?unitGroup=metric&include=current&key=#{@api_key}&contentType=json"
    response = HTTParty.get(url)
    @weather = response["days"][0]["description"]
    return @weather
  end
end
