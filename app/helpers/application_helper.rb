module ApplicationHelper
  
  # active record error message
  def activerecord_error_message(key, options = {})
    I18n.t key, {:scope => [:activerecord, :errors, :messages]}.merge(options)
  end
  
  # return the humanized action name.
  # It refers to I18n entries as following.
  # * <locale>/controllers/<controller>/actions/<action> if  the controller  is specified.
  # * <locale>/controllers/actions/<action> if the controller is not specified.
  def human_action_name(controller, action, options = {})
    I18n.t action, 
      {:scope => if controller;[:controllers, controller];else;[:controllers];end  + [:actions]}.
      merge(options)
  end
    
  # return the message.
  # It refers to I18n entries as following.
  # * <locale>/controllers/<controller>/messages/<key> if  the controller  is specified.
  # * <locale>/controllers/messages/s<key> if the controller is not specified.
  def message(controller, key, options = {})
    I18n.t key, 
      {:scope => if controller;[:controllers, controller];else;[:controllers];end  + [:messages]}.
      merge(options)
  end
  
  # Return the note about activerecord model attribute.
  # It refers to I18n entries as following.
  # * <locale>/activerecord/attribute_notes/<model>/<attribute> 
  def note_about_attribute(model, attribute)
    I18n.t attribute, :scope => [:activerecord, :attribute_notes, model]
  end

  # Return the activerecord model attribute humanized value.
  # It refers to I18n entries as following.
  # * <locale>/activerecord/attribute_values/<model>/<attribute>/<value> 
  def human_attribute_value(model, attribute, value)
    I18n.t value, :scope => [:activerecord, :attribute_values, model, attribute]
  end
  
  # Return the mark.
  # It refers to I18n entries as following.
  # * <locale>/application_helpers/marks/<key> 
  def mark(key)
    I18n.t key, :scope => [:application_helpers, :marks]
  end

  # Return the entry name.
  # It refers to I18n entries as following.
  # * <locale>/application_helpers/marks/<key> 
  def entry_name(key)
    I18n.t key, :scope => [:application_helpers, :entry_names]
  end
  

  
  # get side widgets
  def side_widgets
    @side_widgets ||= 
    if current_folder
      widget_set = WidgetSet.side_widget_set_by_folder(current_folder).first
      if widget_set
        widget_set.elements.collect do |element|
          element.widget
        end
      end
    elsif current_site
      widget_set = current_site.side_widget_set
      if widget_set
        widget_set.elements.collect do |element|
          element.widget
        end
      end
    else
      nil
    end
  end
  
  # Create a  link  tag of  archive of given month.
  # == parameters
  # * month
  # * folder - Folder record
  # * options - key => option name, value => option value 
  # ** :format - :default | :short | :long
  # ** :only_path - true | false
  def link_to_monthly_articles(month, folder, options = {})
    month = if month.instance_of?(String);Date.parse(month);else;month;end
    link_to(localized_month(month, options[:format] || :default), 
          url_for(:controller => :articles, :action => :month, 
            :folder => if folder.respond_to?(:name);folder.name;else;folder.to_s;end,
            :site => get_site(options.merge({:folder => folder})),
            :year => month.year, :month => month.month, 
            :only_path => if options.has_key?(:only_path);options[:only_path];else;false;end))
  end

  # Create a  link  tag of the article.
  # == parameters
  # * article - Article record
  # * options - key => option name, value => option value 
  # ** :only_path - true | false
  def link_to_article(article, options = {})
    link_to(article.title,
          article_path(article, 
                    {:action => :show,
                    :site => get_site(options.merge({:folder => article.folder})),
                    :folder => article.folder,
                    :only_path => if options.has_key?(:only_path);options[:only_path];else;false;end
                    }))
  end

  # Create a  link  tag of the article.
  # == parameters
  # * folder - Folder record
  # * options - key => option name, value => option value 
  # ** :only_path - true | false
  def link_to_folder(folder, options = {})
    link_to(folder.title,
            articles_path(
                        {:action => :index,
                        :folder => folder,
                        :site => get_site(options.merge({:folder => folder})),
                        :only_path => if options.has_key?(:only_path);options[:only_path];else;false;end
                        } ) )
  end

  # Returns header image path
  def header_image_path
    page_design = (current_folder && current_folder.page_design) 
    page_design = 
    unless page_design && page_design.header_image_exist?
      (current_site  && current_site.page_design)
    end || page_design
    if page_design
      page_design_path(page_design, :action => :header_image)
    else
      ''
    end
  end

  # Returns header image url
  def header_image_url
    page_design = (current_folder && current_folder.page_design) 
    page_design = 
    unless page_design && page_design.header_image_exist?
      (current_site  && current_site.page_design)
    end || page_design
    if page_design
      page_design_url(page_design, :action => :header_image)
    else
      ''
    end
  end
  
  # Returns header image tag
  def header_image_tag
    if url = header_image_url
      image_tag(url)
    else
      ''
    end
  end
  
  # Returns background image path
  def background_image_path
    page_design = (current_folder && current_folder.page_design) 
    page_design = 
    unless page_design && page_design.background_image_exist?
      (current_site  && current_site.page_design)
    end || page_design
    if page_design
      page_design_path(page_design, :action => :background_image)
    else
      ''
    end
  end

  # Returns background image url
  def background_image_url
    page_design = (current_folder && current_folder.page_design) 
    page_design = 
    unless page_design && page_design.background_image_exist?
      (current_site  && current_site.page_design)
    end || page_design
    if page_design
      page_design_url(page_design, :action => :background_image)
    else
      ''
    end
  end
  
  # Returns background image tag
  def background_image_tag
    if url = background_image_url
      image_tag(url)
    else
      ''
    end
  end
  
  # whether the background image exist or not.
  def background_image_exist?
    page_design = (current_folder && current_folder.page_design) 
    page_design = 
    unless page_design && page_design.background_image_exist?
      (current_site  && current_site.page_design)
    end || page_design
    !!(page_design && page_design.background_image_exist?)
  end

  # whether the header image exist or not.
  def header_image_exist?
    page_design = (current_folder && current_folder.page_design) 
    page_design = 
    unless page_design && page_design.header_image_exist?
      (current_site  && current_site.page_design)
    end || page_design
    !!(page_design && page_design.header_image_exist?)
  end
  
  # Returns background style 
  def background_style
    page_design = (current_folder && current_folder.page_design) 
    page_design = 
    if page_design.nil? || page_design.background_interited_from_site
      (current_site  && current_site.page_design)
    end || page_design
    if page_design
      '<style type="text/css">' +
      " \n #page_wrapper { \n" +
      # image
      if url = page_design_url_by_site_and_folder(current_site, current_folder, :action => :background_image)
        "background-image: url(#{url});" + "\n"
      end.to_s +
      # repeat
      if repeat = page_design.background_repeat
      end.to_s +
      # position
      if position = page_design.background_position
        "background-position: #{position};" + "\n"
      end.to_s +
      # attachment
      if attachment = page_design.background_attachment
        "background-attachment: #{attachment};" + "\n"
      end.to_s +
      # color
      if color = page_design.background_color
        "background-color: #{color};" + "\n"
      end.to_s +
      "} \n" +
      '</style>'
    else
      ''
    end.html_safe
  end
  
  # Returns user stylsheet contents.
  def user_stylesheet
    page_design = (current_folder && current_folder.page_design) 
    page_design = 
    if page_design.nil? || page_design.stylesheet.to_s.strip.blank?
      (current_site  && current_site.page_design)
    end || page_design
    if page_design && !page_design.stylesheet.blank?
      ('<style type="text/css">' +
      page_design.stylesheet +
      '</style>').html_safe
    else
      ''
    end
  end
  
  # Returns user header html contents.
  def user_header
    page_design = (current_folder && current_folder.page_design) 
    page_design = 
    if page_design.nil? || page_design.header_html.to_s.strip.blank?
      (current_site  && current_site.page_design)
    end || page_design
    if page_design &&  !page_design.header_html.to_s.strip.blank?
      page_design.header_html
    else
      ''
    end.html_safe
  end

  # Returns user footer html contents.
  def user_footer
    page_design = (current_folder && current_folder.page_design) 
    page_design = 
    if page_design.nil? || page_design.footer_html.to_s.strip.blank?
      (current_site  && current_site.page_design)
    end || page_design
    if page_design &&  !page_design.footer_html.to_s.strip.blank?
      page_design.footer_html
    else
      ''
    end.html_safe
  end
  
  
  # return the current login user
  def current_user
    @current_user
  end
  
  # return the current site
  def current_site
    @current_site ||= if @site && !@site.new_record?;@site;end
  end
  
  # return the current folder
  def current_folder
    @current_folder ||= if @folder && !@folder.new_record?;@folder;else;default_folder;end
  end
  
  # return folders which the current user can edit.
  def editable_folders
    if current_user
      current_user.editable_folders(@site)
    else
      []
    end
  end
  
  # Gets the default folder
  def default_folder
    @default_folder = 
    if current_user
      current_user.default_folder
    else
      if @site
        @site.default_folder
      else
        nil
      end
    end
  end
  
  
  def render_menu(menu)
    def render_menu_recursive(menu_items, depth)
      menu_items.inject("<ul class='top_menu_#{depth} droppy'>") do |html, child|
        html + 
        if child.children_count > 0
          "<li>" + 
          render_menu_item_link(child) +
          render_menu_recursive(child.children, depth + 1) +
          "</li>"
          
        else
          render_menu_item(child)  + "\n"
        end
      end + "</ul>"
    end

    if menu
      render_menu_recursive(menu.menu_items.roots, 1)
    else
      ''
    end.html_safe
  end
  
  def render_menu_item(menu_item)
    ("<li>" + render_menu_item_link(menu_item) + "</li>")
  end
  
  def render_menu_item_link(menu_item)
    link_to(menu_item.title_for_display, 
    if menu_item.folder
      folder_path(menu_item.folder, :action => :index)
    else
      '#'
    end)
  end
  
  # Creates the stylesheet link tag of the selected theme.
  # == option parameters
  # * :media
  def theme_stylesheet_link_tag(options = {})
    theme = 
    Proc.new do 
      record = (current_folder || current_site) 
      if record
        record.theme
      else
        Design::Theme.array.find_by_name('Default')
      end
    end.call
    options = {:media => :all}.merge(options)
    if theme 
      ("<link href=\"#{theme.stylesheet_url}?body=1 " +
      "media=\"#{options[:media]}\" rel=\"stylesheet\" type=\"text/css\" />").html_safe
#      stylesheet_link_tag(record.theme.stylesheet_url)
    else
      ''
    end
  end
  
  # Returns the localized 
  # == parameters
  # * ym - Date object or String object (that can be parsed to the date)
  # * format - :default | :short | :long
  def localized_month(ym, format = :default)
    #ym
    ym = if ym.kind_of?(String);Date.parse(ym);else;ym;end
    ym.strftime(I18n.t(format, :scope => [:month, :date, :formats]))
  end


  protected
  
  def get_site(options = {})
    folder ||= options[:folder]
    if folder.respond_to?(:name)
      folder.site.name
    else
      site = options[:site]
      if site.nil? 
        params[:site]
      else
        if site.respond_to?(:name) 
          site.name 
        else 
          site 
        end
      end
    end
  end
  
  
end
