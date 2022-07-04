class Meteofrance::Api::Forecast
  # position information of the forecast. A Hash with metadata about the position of the forecast place.
  attr_reader :position
  # update Time of the forecast.
  attr_reader :updated_on
  # daily forecast for the following days.
  # A list of Hash to describe the daily forecast for the next 15 days.
  attr_reader :daily_forecast
  # hourly forecast.
  # A list of Hash to describe the hourly forecast for the next day
  attr_reader :forecast
  # wheather event forecast.
  # A list of Hash to describe the event probability forecast (rain, snow, freezing) for next 10 days.
  attr_reader :probability_forecast

  def initialize(data)
    @position = data["position"]
    @updated_on = Time.at(data["updated_on"])
    @daily_forecast = data["daily_forecast"]
    @forecast = data["forecast"]
    @probability_forecast = data.dig("probability_forecast", [])
  end

  # Return the forecast for today. A Hash corresponding to the daily forecast for the current day
  def today_forecast
    self.daily_forecast.first
  end

  # Return the nearest hourly forecast. A Hash corresponding to the nearest hourly forecast.
  def nearest_forecast
    # get timestamp for current time
    now_timestamp = Time.now.utc.to_i

    # sort list of forecast by distance between current timestamp and
    # forecast timestamp
    sorted_forecast = self.forecast.sort_by {|f| (f["dt"] - now_timestamp).abs }

    sorted_forecast.first
  end

  # Return the forecast of the current hour. A Hash corresponding to the hourly forecast for the current hour
  def current_forecast
    # Get the timestamp for the current hour.
    current_hour = Time.now.utc.to_a
    current_hour[0] = 0
    current_hour[1] = 0
    current_hour_timestamp = Time.utc.new(*current_hour).to_i

    # create a Hash using timestamp as keys
    forecast_by_datetime = self.forecast.map {|f| [f["dt"], f]}.to_h

    # Return the forecast corresponding to the timestamp of the current hour if
    # exists.
    forecast_by_datetime[current_hour_timestamp]
  end

  # Convert time in the forecast location timezone
  def to_locale_time(time)
    time.in_time_zone(position["timezone"])
  end
end
