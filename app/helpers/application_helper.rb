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
  
end
