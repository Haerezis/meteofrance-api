class MeteofranceApi::Rain::Forecast
  attr_reader :time
  attr_reader :intensity
  attr_reader :description

  def intensity(data)
    @time = Time.parse(data["time"])
    @intensity = data["rain_intensity"]
    @description = data["rain_intensity_description"]
  end
end
