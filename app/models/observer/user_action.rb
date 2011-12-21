module Observer
  
  # Observes model classes updating,
  # and setting the updated_by and created_by attributes.
  class UserAction < ActiveRecord::Observer
    
    # Observed model classes
    observe Site, Folder, Article, Image, Menu, MenuItem, WidgetSet

    def current_user=(user)
      self.class.current_user = user
    end
    def self.current_user=(user)
      Thread.current[:current_user] = user
    end

    def current_user
      self.class.current_user
    end
    def self.current_user
      Thread.current[:current_user]
    end

    def before_create(model)
      if self.current_user
        model.created_by = self.current_user
        model.updated_by = self.current_user
      end
    end

    def before_update(model)
      if self.current_user
        model.updated_by = self.current_user
      end
    end
    
  end
  
end