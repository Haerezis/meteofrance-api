class MeteofranceApi::Warning::Phenomenon
  attr_reader :id
  attr_reader :max_color_id

  def initialize(data)
    @id = data["phenomenon_id"]
    @max_color_id = data["phenomenon_max_color_id"]
  end
end
