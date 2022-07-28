class MeteofranceApi::Weather
  # update Time of the forecast.
  attr_reader :updated_at

  # position information of the forecast. An Array [longitude, latitude].
  attr_reader :position
  # Altitude of the position (in meter)
  attr_reader :altitude
  # Name of the position
  attr_reader :name
  # Country of the position
  attr_reader :country
  attr_reader :timezone
  attr_reader :insee
  attr_reader :french_department_code

  attr_reader :bulletin_cote

  # daily forecast for the following days.
  # A list of Hash to describe the daily forecast for the next 15 days.
  attr_reader :daily_forecasts
  # hourly forecast.
  # A list of Hash to describe the hourly forecast for the next day
  attr_reader :forecasts
  # wheather event forecast.
  # A list of object to describe the event probability forecast (rain, snow, freezing) for next 10 days.
  attr_reader :hazard_forecasts


  def initialize(data)
    @updated_on = Time.at(data["updated_time"])

    @position = data["geometry"]["coordinates"]
    @altitude = data["properties"]["altitude"]
    @name = data["properties"]["name"]
    @country = data["properties"]["country"]
    @timezone = data["properties"]["timezone"]
    @insee = data["properties"]["insee"]&.to_i
    @french_department_code = data["properties"]["french_department_code"]&.to_i

    @bulletin_cote = data["properties"]["bulletin_cote"]

    @daily_forecasts = data.dig("daily_forecast", []).map {|d| MeteofranceApi::Weather::DailyForecast.new(d)}
    @forecasts = data.dig("forecast", []).map {|d| MeteofranceApi::Weather::Forecast.new(d)}
    @hazard_forecasts = data.dig("probability_forecast", []).map {|d| MeteofranceApi::Weather::HazardForecast.new(d)}
  end

  # Return the forecast for today. A Hash corresponding to the daily forecast for the current day
  def today_forecast
    self.daily_forecasts.first
  end

  # Return the nearest hourly forecast. A Hash corresponding to the nearest hourly forecast.
  def nearest_forecast
    # get timestamp for current time
    now_timestamp = Time.now

    # sort list of forecast by distance between current timestamp and
    # forecast timestamp
    sorted_forecasts = self.forecasts.sort_by {|f| (f.time - now_timestamp).abs }

    sorted_forecasts.first
  end

  # Return the forecast of the current hour. A Hash corresponding to the hourly forecast for the current hour
  def current_forecast
    # Get the timestamp for the current hour.
    current_hour = Time.now.utc.to_a
    current_hour[0] = 0
    current_hour[1] = 0
    current_hour_timestamp = Time.utc.new(*current_hour).to_i

    # create a Hash using timestamp as keys
    forecasts_by_datetime = self.forecasts.map {|f| [f.time.to_i, f]}.to_h

    # Return the forecast corresponding to the timestamp of the current hour if
    # exists.
    forecasts_by_datetime[current_hour_timestamp]
  end

  # Convert time in the forecast location timezone
  def to_locale_time(time)
    time.in_time_zone(timezone)
  end
end

require "meteofrance_api/models/weather/forecast"
require "meteofrance_api/models/weather/daily_forecast"
require "meteofrance_api/models/weather/hazard_forecast"
