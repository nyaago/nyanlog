module Attribute
  # = OrderOfDisplayOrder
  # mix-in module for the activerecord class which has 'order_of_display' attribute.
  module OrderOfDisplay

    module ClassMethods
      
      def parent_attrs(*attrs)
        @parent_attrs ||= []
        @parent_attrs += attrs.delete_if {|elem| @parent_attrs.include?(elem) }
      end

      # ordered by specification always?
      def ordered_by_specification_always(f)
        @ordered_by_specification_always = f
      end

      # ordered by specification always?
      def ordered_by_specification_always?
        @ordered_by_specification_always || false
      end
      
    end  # ClassMethods
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
  
    # The order of a display is moved ahead. 
    def move_ahead!
      other = self.class.where("order_of_display < ?", self.order_of_display).
                    order('order_of_display desc')
      other = self.class.parent_attrs.reduce(other) do |other, attr|
        if v = send(attr)
          other.where("#{attr.to_s} = ?", v)
        else
          other.where("#{attr.to_s} IS NULL")
        end
      end.first
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
                    order('order_of_display asc')
      other = (self.class.parent_attrs.reduce(other) do |other, attr|
        if v = send(attr)
          other.where("#{attr.to_s} = ?", v)
        else
          other.where("#{attr.to_s} IS NULL")
        end
      end).first
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
      if folder && folder.ordered_by_specification? || self.class.ordered_by_specification_always?
        self.order_of_display = 
        if max = 
        (self.class.parent_attrs.reduce(self.class) do |other, attr|
          if v = send(attr)
            other.where("#{attr.to_s} = ?", v)
          else
            other.where("#{attr.to_s} IS NULL")
          end
        end).maximum('order_of_display')
          max + 1
        else
          1
        end
      end
    end
  
  end # OrderOfDisplay
  
end   # Attribute