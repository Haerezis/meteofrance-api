class MeteofranceApi::Place

  # INSEE ID of the place.
  attr_reader :insee
  # name of the place.
  attr_reader :name
  # latitude of the place.
  attr_reader :latitude
  # longitude of the place.
  attr_reader :longitude
  # country code of the place.
  attr_reader :country
  # admin of the place.
  attr_reader :admin
  # admin2 of the place.
  attr_reader :admin2
  # postal code of the place.
  attr_reader :postal_code

  def initialize(data)
    @insee = data["insee"]
    @name = data["name"]
    @latitude = data["lat"]
    @longitude = data["lon"]
    @country = data["country"]
    @admin = data["admin"]
    @admin2 = data["admin2"]
    @postal_code = data["postCode"]
  end

  def to_s
    if country == "FR"
      "#{name} - #{admin} (#{admin2}) - #{country}"
    else
      "#{name} - #{admin} - #{country}"
    end
  end
end
