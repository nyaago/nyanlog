module AppConfig
  
  # configulations about the widget
  # * the configulation file path is the <appklication>/config/widgets/*.yml
  # == elementns
  class Widget < Arrayed

    TRANSLATION_SCOPE = [:widgets]

    attr_accessor :name
    attr_writer   :title, :description
    
    # Returns the title.
    # Returns the  I18n resource (<locale>/:widgets/<name>/:title ) ,
    # or the configulation resource (:widgets/<name>/)
    def title
      begin 
        I18n.t(:title, :scope => TRANSLATION_SCOPE + [name], :raise => true) 
      rescue
        @title
      end
    end
    
    # Returns the description.
    # Returns the I18n resource (<locale>/:widgets/<name>/:description ) or @description
    def description
      begin
        I18n.t(:description, :scope => TRANSLATION_SCOPE + [name], :raise => true)
      rescue
        @description
      end
    end
    
    # Returns the model class name.
    def class_name
      name.camelize
    end
    
  end

end

