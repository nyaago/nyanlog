module SitesHelper

  # Returns array of widget sets for select tag
  def widget_sets_of_site_for_select(site)
    [[ human_attribute_value(:site, :widget_set_id, :none),nil]] +
    site.widget_sets.collect do |widget_set|
      [widget_set.title, widget_set.id]
    end
  end

  # Generates url options  from the request parameters.
  # Returns - url options (hash).
  def url_options_from_params
    {:page => if !params[:page].blank?  then params[:page]  else nil end,
    :sort => if !params[:sort].blank?  then params[:sort]  else nil end,
    :direction => if !params[:direction].blank?  then params[:direction]  else nil end}
  end
      
end
