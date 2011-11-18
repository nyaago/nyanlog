module Attribute
  # = OrderOfDisplayOrder
  # mix-in module for the activerecord class which has 'order_of_display' attribute.
  module OrderOfDisplay
  
    # The order of a display is moved ahead. 
    def move_ahead!
      other = self.class.where("order_of_display < ?", self.order_of_display).
                    order('order_of_display desc').
                    first
      if other 
        my_order = self.order_of_display
        self.order_of_display = other.order_of_display
        other.order_of_display = my_order
        class << self
          def record_timestamps; false; end
        end
        class << other
          def record_timestamps; false; end
        end
        begin 
          self.save!(:validate => false)
          other.save!(:validate => false)
        ensure
          class << self
            remove_method :record_timestamps
          end
        end
      end
    end

    # The order of a display is moved behind. 
    def move_behind!
      other = self.class.where("order_of_display > ?", self.order_of_display).
                    order('order_of_display asc').
                    first
      if other 
        class << self
          def record_timestamps; false; end
        end
        class << other
          def record_timestamps; false; end
        end
        my_order = self.order_of_display
        self.order_of_display = other.order_of_display
        other.order_of_display = my_order
        begin
          self.save!(:validate => false)
          other.save!(:validate => false)
        ensure
          class << self
            remove_method :record_timestamps
          end
        end
      end
    end

    private

    # if ordering type of the folder is 'ordering_specifying',
    # set the order of display
    def set_order_of_display!
      if folder.ordered_by_specification?
        order_of_display = 
        if max = folder.articles.maximum('order_of_display')
          max + 1
        else
          1
        end
      end
    end
  
  end
  
end