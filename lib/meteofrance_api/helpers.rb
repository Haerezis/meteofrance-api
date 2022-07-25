require "meteofrance_api/constants"

module MeteofranceApi::Helpers
  # Convert the color code in readable text.
  #
  # Args:
  #    color_code: Color status in int. Value expected between 1 and 4.
  #    lang(Optional):  If language is equal :fr (default value) results will
  #                     be in French. All other value will give results in English.

  #Returns:
      #Color status in text. French or English according to the lang parameter.
  def color_code_to_str(
    code,
    lang = :fr
  )
    colors = MeteofranceApi::ALERT_COLORS[lang] || MeteofranceApi::ALERT_COLORS[:en]

    colors[code]
  end


  #    Convert the phenomenom code in readable text (Hepler).
  #
  #    Args:
  #        code: ID of the phenomenom in int. Value expected between 1 and 9.
  #        lang: Optional; If language is equal :fr (default value) results will
  #            be in French. All other value will give results in English.
  #
  #    Returns:
  #        Phenomenom in text. French or English according to the lang parameter.
  def alert_code_to_str(
    code,
    lang = :fr
  )
    alert_types = MeteofranceApi::ALERT_TYPES[lang] || MeteofranceApi::ALERT_TYPES[:en]

    alert_types[code]
  end


  #  Identify when a second bulletin is availabe for coastal risks (Helper).
  #
  #  Args:
  #      department_number: Department number on 2 characters
  #
  #  Returns:
  #      True if the department have an additional coastal bulletin. False otherwise.
  #  
  def is_coastal_department?(department_number)
    MeteofranceApi::COASTAL_DEPARTMENTS.include?(department_number)
  end


  #  Identify if there is a weather alert bulletin for this department (Helper).
  #
  #  Weather alert buletins are available only for metropolitan France and Andorre.
  #
  #  Args:
  #      department_number: Department number on 2 characters.
  #
  #  Returns:
  #      True if a department is metropolitan France or Andorre.
  #  
  def is_department?(department_number)
    MeteofranceApi::VALID_DEPARTMENTS.include?(department_number)
  end

  #  Compute distance in meters between to GPS coordinates using Harvesine formula.
  #
  #  source: https://janakiev.com/blog/gps-points-distance-python/
  #
  #  Args:
  #      coord1: Tuple with latitude and longitude in degrees for first point
  #      coord2: Tuple with latitude and longitude in degrees for second point
  #
  #  Returns:
  #      Distance in meters between the two points
  def haversine(coord1, coord2)
    to_radians = ->(v) { v * (Math::PI / 180) }
    radius = 6372800  # Earth radius in meters

    lat1, lon1 = coord1
    lat2, lon2 = coord2

    phi1, phi2 = to_radians.call(lat1), to_radians.call(lat2)
    dphi = to_radians.call(lat2 - lat1)
    dlambda = to_radians.call(lon2 - lon1)

    a = (
        Math.sin(dphi / 2) ** 2
        + Math.cos(phi1) * Math.cos(phi2) * Math.sin(dlambda / 2) ** 2
    )

    return 2 * radius * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  end


  #  Order list of places according to the distance to a reference coordinates.
  #
  #  Note: this helper is compensating the bad results of the API. Results in the API
  #  are generally sorted, but lot of cases identified where the order is inconsistent
  #  (example: Montréal)
  #
  #  Args:
  #      list_places: List of Place instances to be ordered
  #      gps_coord: Tuple with latitude and longitude in degrees for the reference point
  #
  #  Returns:
  #      List of Place instances ordered by distance to the reference point (nearest
  #          first)
  #  
  def sort_places_versus_distance_from_coordinates(
      places,
      gps_coord
  )
    places.sort_by {|place| haversine(place.latitude.to_i, place.longitude.to_i, gps_coord)}
  end
end
