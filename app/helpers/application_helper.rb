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
  # * <locale>/activerecord/attributes/<model>/notes/<attribute> 
  def note_about_attribute(model, attribute)
    I18n.t attribute, :scope => [:activerecord, :attributes, model, :notes]
  end

  # Return the activerecord model attribute humanized value.
  # It refers to I18n entries as following.
  # * <locale>/activerecord/attributes/<model>/<attribute>/<value> 
  def human_attribute_value(model, attribute, value)
    I18n.t value, :scope => [:activerecord, :attributes, :values, model, attribute]
  end
  
  # Return the mark.
  # It refers to I18n entries as following.
  # * <locale>/application_helpers/marks/<key> 
  def mark(key)
    I18n.t key, :scope => [:application_helpers, :marks]
  end
  
  # get side widgets
  def side_widgets
    @side_widgets ||= 
    if instance_variable_defined?(:@folder) && @folder
      widget_set = WidgetSet.side_widget_set_by_folder(@folder).first
      if widget_set
        widget_set.elements.collect do |element|
          element.widget
        end
      end
    elsif instance_variable_defined?(:@site) && @site
      widget_set = @site.side_widget_set
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
            :site => site(options.merge({:folder => folder})),
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
                    :site => site(options.merge({:folder => article.folder})),
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
                        :site => site(options.merge({:folder => folder})),
                        :only_path => if options.has_key?(:only_path);options[:only_path];else;false;end
                        } ) )
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
      menu_items.inject("<ul class='top_menu_#{depth}'>") do |html, child|
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
      folder_path(menu_item.folder)
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
  
  def site(options = {})
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
