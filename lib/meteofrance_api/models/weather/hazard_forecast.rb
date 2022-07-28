class MeteofranceApi::Weather::HazardForecast
  attr_reader :rain_hazard_3h
  attr_reader :rain_hazard_6h
  attr_reader :snow_hazard_3h
  attr_reader :snow_hazard_6h
  attr_reader :freezing_hazard
  attr_reader :storm_hazard

  def initialize(data)
  @rain_hazard_3h = data["rain_hazard_3h"]
  @rain_hazard_6h = data["rain_hazard_6h"]
  @snow_hazard_3h = data["snow_hazard_3h"]
  @snow_hazard_6h = data["snow_hazard_6h"]
  @freezing_hazard = data["freezing_hazard"]
  @storm_hazard = data["storm_hazard"]
  end
end
