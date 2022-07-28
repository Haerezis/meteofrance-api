class MeteofranceApi::Weather::Forecast
  attr_reader :time

  attr_reader :temperature
  attr_reader :temperature_windchill
  attr_reader :relative_humidity

  attr_reader :total_cloud_cover

  attr_reader :weather_description
  attr_reader :weather_icon

  attr_reader :wind_direction
  attr_reader :wind_icon
  attr_reader :wind_speed
  attr_reader :wind_speed_gust

  attr_reader :rain_1h
  attr_reader :rain_3h
  attr_reader :rain_6h
  attr_reader :rain_12h
  attr_reader :rain_24h

  attr_reader :rain_snow_limit

  attr_reader :snow_1h
  attr_reader :snow_3h
  attr_reader :snow_6h
  attr_reader :snow_12h
  attr_reader :snow_24h

  attr_reader :P_sea

  attr_reader :iso0


  def initialize(data)
    @time = Time.parse(data["time"])
    @temperature = data["T"]
    @temperature_windchill = data["T_windchill"]
    @relative_humidity = data["relative_humidity"]
    @P_sea = data["P_sea"]
    @wind_speed = data["wind_speed"]
    @wind_speed_gust = data["wind_speed_gust"]
    @wind_direction = data["wind_direction"]
    @wind_icon = data["wind_icon"]
    @rain_1h = data["rain_1h"]
    @rain_3h = data["rain_3h"]
    @rain_6h = data["rain_6h"]
    @rain_12h = data["rain_12h"]
    @rain_24h = data["rain_24h"]
    @snow_1h = data["snow_1h"]
    @snow_3h = data["snow_3h"]
    @snow_6h = data["snow_6h"]
    @snow_12h = data["snow_12h"]
    @snow_24h = data["snow_24h"]
    @iso0 = data["iso0"]
    @rain_snow_limit = data["rain_snow_limit"]
    @total_cloud_cover = data["total_cloud_cover"]
    @weather_icon = data["weather_icon"]
    @weather_description = data["weather_description"]
  end
end
