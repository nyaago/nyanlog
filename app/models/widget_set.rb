class WidgetSet < ActiveRecord::Base

  require 'csv'

  # Sets owner if owner is nil (set same value with the created_by user).
  after_create  :set_owner_if_nil!

  belongs_to  :site
  belongs_to  :owner, :class_name => 'User',
              :foreign_key => 'owner_id'
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  has_many    :elements, :class_name => 'WidgetSetElement'
#  has_many    :widgets, :through => :elements,
#              :source => :widget
  #            
  
  scope :listing, order('updated_at desc')
  #
  scope :by_id, lambda { |widget_set_or_id|  
                          where("id = ?", if widget_set_or_id.respond_to?(:id)
                                            widget_set_or_id.id
                                          else
                                            widget_set_or_id
                                          end) }
  # 
  scope :side_widget_set_by_folder, lambda { |folder| 
                      id = if folder.side_widget_set_id
                        folder.side_widget_set_id
                      else
                        if folder.site
                          folder.site.side_widget_set_id
                        end
                      end
                      if id
                        where("id = ?", id)
                      else
                        where("1 = 2")
                      end
                    }

  # filtering(can manage for the user)
  scope   :can_manage_for, lambda { |user|
    if user.is_admin
      where("")
    elsif user.can_manage_site?(user.site)
      where("site_id = ?", user.site_id)
    else
      where("owner_id = ?", user.id)
    end
  }

  #
  validates_presence_of :site_id

  # sort elements 
  # == parameters
  # * id_separated_by_comma  - list of id(comma separated values)
  def sort_elements_by_id_list(id_separated_by_comma)
    id_list = CSV.parse_line(id_separated_by_comma).collect do |id|
      id.to_i
    end
    max = id_list.size
    elements.each do |element|
      element.order_of_display = 
      if index = id_list.index(element.id) 
        index + 1
      else
         (max += 1)
      end
      def element.record_timestamps; false; end
      element.save!(:validate => false)
    end
  end
  
  private
  
  # Sets owner if owner is nil (set same value with the created_by user).
  def set_owner_if_nil!
    if self.owner_id.nil?
      self.owner_id = self.created_by
    end
    self.save!(:validate => false)
    true
  end
  
end
