# Constants for Météo-France weather forecast python API.
module MeteofranceApi::Constants
  API_URL = "https://webservice.meteofrance.com"
  API_TOKENS = [
    # noqa: S105
    "__Wj7dVSTjV9YGu1guveLyDq0g7S7TfTjaHBTPTpO0kj8__",
    # noqa: B951
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzRjdFOTVGOS04QjIxLTQwMDctOTFCQi0wQ0M3QjlBNTQxQzQiLCJjbGFzcyI6Im1vYmlsZSIsImlhdCI6MTYzNDg0NjM1Mi40NzU0MTE5fQ.F02c4y95-HqMsMbQeJ5Cx-qQ4LDJgaYwl47YsNvJM0E",
  ]

  # enums used in all Warning classes. First indice is 0
  # Weather alert criticity
  ALERT_COLORS_FR = [nil, "Vert", "Jaune", "Orange", "Rouge"]
  ALERT_COLORS_EN = [nil, "Green", "Yellow", "Orange", "Red"]
  ALERT_COLORS = {
    fr: ALERT_COLORS_FR,
    en: ALERT_COLORS_EN,
  }

  # Weather alert type
  ALERT_TYPES_FR = [
      nil,
      "Vent violent",
      "Pluie-inondation",
      "Orages",
      "Inondation",
      "Neige-verglas",
      "Canicule",
      "Grand-froid",
      "Avalanches",
      "Vagues-submersion",
  ]
  ALERT_TYPES_EN = [
      nil,
      "Wind",
      "Rain-Flood",
      "Thunderstorms",
      "Flood",
      "Snow/Ice",
      "Extreme high temperature",
      "Extreme low temperature",
      "Avalanches",
      "Coastal Event",
  ]
  ALERT_TYPES = {
    fr: ALERT_TYPES_FR,
    en: ALERT_TYPES_EN,
  }


  # Valide departments list for weather alert bulletin
  VALID_DEPARTMENTS = (1..95).to_a + [
    "2A",
    "2B",
    "99",
  ].map {|v| v.to_s.rjust(2, "0")}.sort

  # Area code list for Coastal Departments
  COASTAL_DEPARTMENTS = [
      "06",
      "11",
      "13",
      "14",
      "17",
      "22",
      "29",
      "2A",
      "2B",
      "30",
      "33",
      "34",
      "35",
      "40",
      "44",
      "50",
      "56",
      "59",
      "62",
      "64",
      "66",
      "76",
      "80",
      "83",
      "85",
  ]
end
