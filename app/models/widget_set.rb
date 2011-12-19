class WidgetSet < ActiveRecord::Base

  belongs_to  :site
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
  
end
