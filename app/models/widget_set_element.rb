class WidgetSetElement < ActiveRecord::Base
  

  belongs_to  :widget_set
  belongs_to  :widget,  :polymorphic => true
  
  scope :listing, order('order_of_display')
  scope :by_id, lambda { |id| where("id = ?", id)}

  def self.accessible_attributes
    [:widget_set, :widget]    
  end
  
end
