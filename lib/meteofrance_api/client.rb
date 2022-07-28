require "faraday"

require "meteofrance_api/constants.rb"
require "meteofrance_api/models"

class MeteofranceApi::Client
  def initialize(token = MeteofranceApi::Constants::API_TOKENS.first)
    @token = token
  end

  def connection
    @conn ||= Faraday.new(
      url: MeteofranceApi::Constants::API_URL,
      params: {token: @token },
    )
  end


  #  Search the places (cities) linked to a query by name.

  #  You can add GPS coordinates in parameter to search places arround a given
  #  location.

  #  Args:
  #      search_query: A complete name, only a part of a name or a postal code (for
  #          France only) corresponding to a city in the world.
  #      latitude: Optional; Latitude in degree of a reference point to order
  #          results. The nearest places first.
  #      longitude: Optional; Longitude in degree of a reference point to order
  #          results. The nearest places first.

  #  Returns:
  #      A list of places (Place instance) corresponding to the query.
  def search_places(
      search_query,
      latitude: nil,
      longitude: nil
  )
    # Construct the list of the GET parameters
    params = {"q": search_query}
    if !!latitude
      params["lat"] = latitude
    end
    if !!longitude
      params["lon"] = longitude
    end

    # Send the API resuest
    resp = connection.get("/v2/places", params)
    data = JSON.parse(resp.body)

    places = data.map {|datum| MeteofranceApi::Place.new(datum)}

    places
  end

  # Retrieve the weather forecast for a given GPS location.
  #
  # Results can be fetched in french or english according to the language parameter.
  #
  # Args:
  #    latitude: Latitude in degree of the GPS point corresponding to the weather
  #        forecast.
  #    longitude: Longitude in degree of the GPS point corresponding to the weather
  #        forecast.
  #    language: Optional; If language is equal "fr" (default value) results will
  #        be in French. All other value will give results in English.
  #
  # Returns:
  #    A Forecast intance representing the hourly and daily weather forecast.
  #
  def get_forecast(
    latitude,
    longitude,
    language = nil
  )
    language ||= "fr"

    # Send the API request
    resp = connection.get("/v2/forecast", {
      lat: latitude,
      lon: longitude,
      lang: language
    })


    return MeteofranceApi::Forecast.new(JSON.parse(resp.body))
  end

  # Retrieve the weather forecast for a given Place instance.
  #
  # Results can be fetched in french or english according to the language parameter.

  # Args:
  #    place: Place class instance corresponding to a location.
  #    language: Optional; If language is equal "fr" (default value) results will
  #        be in French. All other value will give results in English.
  #
  # Returns:
  #    A Forecast intance representing the hourly and daily weather forecast.
  #
  def get_forecast_for_place(
    place,
    language = nil
  )
    language ||= "fr"

    return get_forecast(place.latitude, place.longitude, language)
  end

  # Retrieve the next 1 hour rain forecast for a given GPS the location.
  # 
  # Results can be fetched in french or english according to the language parameter.
  # 
  # Args:
  #     latitude: Latitude in degree of the GPS point corresponding to the rain
  #         forecast.
  #     longitude: Longitude in degree of the GPS point corresponding to the rain
  #         forecast.
  #     language: Optional; If language is equal "fr" (default value) results will
  #         be in French. All other value will give results in English.
  # 
  # Returns:
  #     A Rain instance representing the next hour rain forecast.
  # 
  def get_rain(latitude, longitude, language = nil)
    # TODO: add protection if no rain forecast for this position

    language ||= "fr"

    # Send the API request
    resp = connection.get("/v2/rain", {
      lat: latitude,
      lon: longitude,
      lang: language
    })

    return MeteofranceApi::Rain.new(JSON.parse(resp.body))
  end

  # Return the current weather phenomenons (or alerts) for a given domain.
  #
  # Args:
  #     domain: could be `france` or any metropolitan France department numbers on
  #         two digits. For some departments you can access an additional bulletin
  #         for coastal phenomenons. To access it add `10` after the domain id
  #         (example: `1310`).
  #     depth: Optional; To be used with domain = 'france'. With depth = 0 the
  #         results will show only natinal sum up of the weather alerts. If
  #         depth = 1, you will have in addition, the bulletin for all metropolitan
  #         France department and Andorre
  #     with_costal_bulletin: Optional; If set to True (default is False), you can
  #         get the basic bulletin and coastal bulletin merged.
  # 
  # Returns:
  #     A warning.CurrentPhenomenons instance representing the weather alert
  #     bulletin.
  # 
  def get_warning_current_phenomenons(domain, depth = 0, with_costal_bulletin = false)
    # Send the API request
    resp = connection.get("/v2/warning/currentphenomenons", {
      domain: domain,
      depth: depth
    })

    # Create object with API response
    phenomenons = MeteofranceApi::Warning::Current.new(JSON.parse(resp.body))


    # if user ask to have the coastal bulletin merged
    if with_costal_bulletin
      if MeteofranceApi::Constants::COASTAL_DEPARTMENTS.include?(domain)
        resp = connection.get("/v2/warning/currentphenomenons", {
          domain: domain + "10",
        })
        coastal_phenomenons = MeteofranceApi::Warning::Current.new(JSON.parse(resp.body))

        phenomenons.merge_with_coastal_phenomenons!(coastal_phenomenons)
      end
    end

    return phenomenons
  end

  # Retrieve a complete bulletin of the weather phenomenons for a given domain.
  # 
  # For a given domain we can access the maximum alert, a timelaps of the alert
  # evolution for the next 24 hours, a list of alerts and other metadatas.
  # 
  # Args:
  #     domain: could be `france` or any metropolitan France department numbers on
  #         two digits. For some departments you can access an additional bulletin
  #         for coastal phenomenons. To access it add `10` after the domain id
  #         (example: `1310`).
  #     with_costal_bulletin: Optional; If set to True (default is False), you can
  #         get the basic bulletin and coastal bulletin merged.
  # 
  # Returns:
  #     A warning.Full instance representing the complete weather alert bulletin.
  # 
  def get_warning_full(domain, with_costal_bulletin = false)
    # TODO: add formatDate parameter

    # Send the API request
    resp = connection.get("/v2/warning/full", {
      domain: domain,
    })

    # Create object with API response
    full_phenomenons = MeteofranceApi::Warning::Full.new(JSON.parse(resp.body))

    # if user ask to have the coastal bulletin merged
    if with_costal_bulletin
      if MeteofranceApi::Constants::COASTAL_DEPARTMENTS.include?(domain)
        resp = connection.get("/v2/warning/full", {
          domain: domain + 10,
        })
        coastal_full_phenomenons = MeteofranceApi::Warning::Full.new(JSON.parse(resp.body))

        full_phenomenons.merge_with_coastal_phenomenons!(coastal_full_phenomenons)
      end
    end

    return full_phenomenons
  end

  #  Retrieve the thumbnail URL of the weather phenomenons or alerts map.
  #
  #  Args:
  #      domain: could be `france` or any metropolitan France department numbers on
  #          two digits.
  #
  #  Returns:
  #      The URL of the thumbnail representing the weather alert status.
  #  
  def get_warning_thumbnail(domain = "france")
    # Return directly the URL of the gif image
    [
      "#{MeteofranceApi::Constants::API_URL}/warning/thumbnail",
      "?",
      URI.encode_www_form({ domain: domain, token: @token }),
    ].join
  end

  #
  #    Retrieve the picture of the day image URL & description.
  #
  #    Args:
  #        domain: could be `france`
  #
  #    Returns:
  #        An array of 2 objects: the image url, and the description
  #
  def get_picture_of_the_day(domain = "france")
    params = {
      domain: domain,
      report_type: "observation",
      report_subtype: "image du jour",
    }

    resp = connection.get(
      "/v2/report",
      params.merge(format: "txt")
    )
    image_description = resp.body

    image_url = [
      "#{MeteofranceApi::Constants::API_URL}/v2/report",
      "?",
      URI.encode_www_form(params.merge(format: "jpg", token: @token))
    ].join

    return [image_url, image_description]
  end
end
