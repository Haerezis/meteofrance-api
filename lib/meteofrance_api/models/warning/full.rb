# This class allows to access the results of a `warning/full` API command.
#
# For a given domain we can access the maximum alert, a timelaps of the alert
# evolution for the next 24 hours, and a list of alerts.
#
# For coastal department two bulletins are avalaible corresponding to two different
# domains.
class MeteofranceApi::Warning::Full
  # update time of the full bulletin.
  attr_reader :update_time
  # end of validty time of the full bulletin.
  attr_reader :end_validity_time
  # domain ID of the the full bulletin. Value is 'France' or a department number.
  attr_reader :domain_id
  # color max of the domain.
  attr_reader :color_max
  # timelaps of each phenomenom for the domain. A list of Hash corresponding to the schedule of each phenomenons in the next 24 hours
  attr_reader :timelaps
  # phenomenom list of the domain.
  attr_reader :phenomenons

  attr_reader :advices
  attr_reader :consequences
  attr_reader :max_count_items
  attr_reader :comments
  attr_reader :text
  attr_reader :text_avalanche

  def initialize(data)
    @update_time = Time.at(data["update_time"])
    @end_validity_time = Time.at(data["end_validity_time"])
    @domain_id = data["domain_id"]
    @color_max = data["color_max"]
    @timelaps = data["timelaps"]
    @phenomenons = (data["phenomenons_items"] || []).map {|i| MeteofranceApi::Warning::Phenomenon.new(i)}

    @advices = data["advices"]
    @consequences = data["consequences"]
    @max_count_items = data["max_count_items"]
    @comments = data["comments"]
    @text = data["text"]
    @text["text_avalanche"]
  end

  # Merge the classical phenomenon bulletin with the coastal one.

  # Extend the color_max, timelaps and phenomenons properties with the content
  #     of the coastal weather alert bulletin.

  # Args:
  #     coastal_phenomenoms: Full instance corresponding to the coastal weather
  #         alert bulletin.
  def merge_with_coastal_phenomenons!(coastal_phenomenons)
    # TODO: Add consitency check
    # TODO: Check if other data need to be merged

    @color_max = [color_max, coastal_phenomenons.color_max].max

    # Merge timelaps
    @timelaps += coastal_phenomenons.timelaps

    # Merge phenomenons
    @phenomenons += coastal_phenomenons.phenomenons
  end
end

require "meteofrance_api/models/warning/phenomenon"
