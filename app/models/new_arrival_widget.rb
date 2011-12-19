class NewArrivalWidget < ActiveRecord::Base

  include Widget

  MAX_ELEMENT_COUNT = 20

  before_validation :set_default!

  validates_numericality_of :element_count, 
                            :greater_than_or_equal_to => 1,
                            :less_than_or_equal_to => 20
  validates_presence_of     :title

  def self.max_element_count
    MAX_ELEMENT_COUNT
  end

  private
  
  def set_default!
    if new_record?
      self.title = self.class.model_name.human
      self.element_count = 5
    end
    true
  end


end
