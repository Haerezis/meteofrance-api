class Meteofrance::Api::Rain
  # position information of the rain forecast.
  attr_reader :position
  # update timestamp of the rain forecast.
  attr_reader :updated_on
  # the rain forecast.
  attr_reader :forecast
  # quality of the rain forecast.
  attr_reader :quality

  def initialize(data)
    @position = data["position"]
    @updated_on = Time.at(data["updated_on"]).utc
    @forecast = data["forecast"]
    @quality = data["quality"]
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
    next_rain = forecast.find {|cadran| cadran["rain"] > 1}

    if next_rain
      # transform next_rain timestamp into Time
      next_rain = Time.at(next_rain["dt"]).utc
    end

    next_rain
  end
end
