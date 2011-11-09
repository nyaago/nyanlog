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
  
  # the note about activerecord model attribute.
  # It refers to I18n entries as following.
  # * <locale>/activerecord/attributes/<model>/notes/<attribute> 
  def note_about_attribute(model, attribute)
    I18n.t attribute, :scope => [:activerecord, :attributes, model, :notes]
  end
  
  # return the current login user
  def current_user
    @current_user
  end
  
  # return the current site
  def current_site
    @current_site ||= @site
  end
  
  # return the current folder
  def current_folder
    @current_folder ||= if @folder;@folder;else;default_folder;end
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
  
  
end
