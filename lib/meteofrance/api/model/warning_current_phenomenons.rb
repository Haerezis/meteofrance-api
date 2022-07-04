# Class to access the results of a `warning/currentPhenomenons` REST API request.
#
# For coastal department two bulletins are avalaible corresponding to two different
# domains.
class WarningCurrentPhenomenons
  # update time of the phenomenoms.
  attr_reader :update_time
  # end of validty time of the phenomenoms.
  attr_reader :end_validity_time
  # domain ID of the phenomenons. Value is 'France' or a department number
  attr_reader :domain_id
  # List of Hash with type of phenomenons and the current alert level
  attr_reader :phenomenons_max_colors

  def initialize(data)
    @update_time = Time.at(data["update_time"])
    @end_validity_time = Time.at(data["end_validity_time"])
    @domain_id = data["domain_id"]
    @phenomenons_max_colors = data["phenomenons_max_colors"]
  end

  # Merge the classical phenomenoms bulleting with the coastal one.

  # Extend the phenomenomes_max_colors property with the content of the coastal
  # weather alert bulletin.

  # Args:
  #     coastal_phenomenoms: WarningCurrentPhenomenons instance corresponding to the
  #         coastal weather alert bulletin.
  # 
  def merge_with_coastal_phenomenons!(coastal_phenomenons)
    # TODO: Add consitency check
    @phenomenons_max_colors += coastal_phenomenoms.phenomenons_max_colors
  end

  # Get the maximum level of alert of a given domain (class helper).
  # Returns:
  #    An integer corresponding to the status code representing the maximum alert.
  def get_domain_max_color
    phenomenons_max_colors.map {|item| item["phenomenon_max_color_id"]}.max
  end
end
