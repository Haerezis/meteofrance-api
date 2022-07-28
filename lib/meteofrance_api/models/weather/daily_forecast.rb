class MeteofranceApi::Weather::DailyForecast
  attr_reader :time

  attr_reader :T_max
  attr_reader :T_min
  attr_reader :T_sea

  attr_reader :relative_humidity_max
  attr_reader :relative_humidity_min

  attr_reader :daily_weather_description
  attr_reader :daily_weather_icon

  attr_reader :sunrise_time
  attr_reader :sunset_time

  attr_reader :total_precipitation_24h

  attr_reader :uv_index

  def initialize(data)
    @time = Time.parse(data["time"])
    @temperature_max = data["T_max"]
    @temperature_min = data["T_min"]
    @temperature_sea = data["T_sea"]
    @relative_humidity_max = data["relative_humidity_max"]
    @relative_humidity_min = data["relative_humidity_min"]
    @weather_description = data["daily_weather_description"]
    @weather_icon = data["daily_weather_icon"]
    @sunrise_time = Time.parse(data["sunrise_time"])
    @sunset_time = Time.parse(data["sunset_time"])
    @total_precipitation_24h = data["total_precipitation_24h"]
    @uv_index = data["uv_index"]
  end
end
