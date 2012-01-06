module PageDesignHelper
  
  def page_design_path(page_design, options = {})
    url_for(options.merge({
    :controller => :page_design,
    :action => 
      if options[:action].blank? 
        'update'
      else 
        options[:action] 
      end,
    :site => page_design.site.name,
    :folder => page_design.folder && page_design.folder.name
    }
    ))
  end
  
  def page_design_url(page_design, options = {})
    page_design_path(page_design, options.merge({:only_path => false}))
  end
  
  # Returns page design rerative url .
  # == parameters
  # * site - site name or Site model record
  # * folder - folder name or Site model record
  # * options
  # ** :action
  def page_design_path_by_site_and_folder(site, folder, options = {})
    url_for(options.merge({
    :controller => :page_design,
    :action => 
      if options[:action].blank? 
        'update'
      else 
        options[:action] 
      end,
    :site => if site.respond_to?(:name);site.name;else;site.to_s;end,
    :folder => 
      if folder
        if folder.respond_to?(:name);folder.name;else;folder.to_s;end
      else
        nil
      end
    }
    ))
  end

  # Returns page design  url .
  # == parameters
  # * site - site name or Site model record
  # * folder - folder name or Site model record
  # * options
  # ** :action
  def page_design_url_by_site_and_folder(site, folder, options = {})
    page_design_path_by_site_and_folder(site, folder, options.merge({:only_path => false}))
  end
  
  def page_designs_path(options = {})
    url_for(options.merge( {
    :controller => :page_design,
    :action => 
      if options[:action].blank? 
        'update'
      else 
        options[:action] 
      end,
    :site => site(options),
    :folder => folder(options)
    }.merge(url_options_from_params) ))
  end

  def page_designs_url(options = {})
    page_design_path(options.merge({:only_path => false}))
  end
  
  # Returns select tag for background repeat
  def select_for_background_repeat(form, separator = ' ')
    PageDesign.background_repeat_entries.inject('') do |s, entry|
      s + form.radio_button(:background_repeat, entry[1]) + entry[0] + separator
    end.html_safe
  end

  # Returns select tag for background position
  def select_for_background_position(form, separator = ' ')
    PageDesign.background_position_entries.inject('') do |s, entry|
      s + form.radio_button(:background_position, entry[1]) + entry[0] + separator
    end.html_safe
  end

  # Returns select tag for background attachment
  def select_for_background_attachment(form, separator = ' ')
    PageDesign.background_attachment_entries.inject('') do |s, entry|
      s + form.radio_button(:background_attachment, entry[1]) + entry[0] + separator
    end.html_safe
  end
  
  
  private 
  
  
  def folder(options)
    folder = options[:folder]
    if folder.nil? 
      params[:folder]
    else
      if folder.respond_to?(:name) 
        folder.name 
      else 
        folder
      end
    end
  end
  
  
end
