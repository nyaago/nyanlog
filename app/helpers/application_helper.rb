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
  
    
end
