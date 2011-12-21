module Widget

  # static methods
  module StaticMethods
    def template
      "/#{self.name.underscore}/index"
    end
  end

  
  def self.included(widget_klass)
    widget_klass.class_eval do
      has_one :widget_set_element, :as => :widget
      has_one :widget_set,  :through => :widget_set_element
      extend(StaticMethods)
    end
  end

  # instance methods
  def template
    self.class.template
  end
  
  # 
  unless self.method_defined?(:title)
#    def title
#      self.class.model_name.human
#    end
  end
  
end