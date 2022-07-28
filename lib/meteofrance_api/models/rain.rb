class MeteofranceApi::Rain
  # update time of the rain forecast.
  attr_reader :updated_on
  # position information of the rain forecast ([latitude, longitude]).
  attr_reader :place_name
  attr_reader :position
  attr_reader :altitude
  attr_reader :french_department
  attr_reader :timezone
  # the rain forecast.
  attr_reader :forecasts
  # quality of the rain forecast.
  attr_reader :confidence

  def initialize(data)
    @updated_on = Time.at(data["updated_time"]).utc
    @position = data["geometry"]["coordinates"]
    @place_name = data["properties"]["name"]
    @altitude = data["properties"]["altitude"]
    @french_department = data["properties"]["french_department"]
    @timezone = data["properties"]["timezone"]
    @forecasts = data["properties"]["forecast"].map {|d| MeteofranceApi::Rain::Forecast.new(d)}
    @confidence = data["properties"]["confidence"]
  end

  def to_locale_timezone(time)
    time.in_time_zone(position["timezone"])
  end

  # Estimate the date of the next rain.
  #
  # Returns:
  #    A datetime instance representing the date estimation of the next rain within
  #    the next hour.
  #    If no rain is expected in the following hour nil is returned.
  def next_rain_date(use_position_timezone)
    # search first cadran with rain
    next_rain = forecasts.find {|f| f.intensity > 1}

    next_rain&.time
  end
end

require "meteofrance_api/models/rain/forecast"
