class WidgetSetElement < ActiveRecord::Base
  
  attr_accessible :widget_set, :widget


  belongs_to  :widget_set
  belongs_to  :widget,  :polymorphic => true
  
  scope :listing, order('order_of_display')
  scope :by_id, lambda { |id| where("id = ?", id)}
  
end
