class MonthlyWidget < ActiveRecord::Base
  
  include Widget
  
  MAX_ELEMENT_COUNT = 20
  
  belongs_to :folder
  
  before_validation :set_default!
  
  validates_numericality_of :element_count, 
                            :greater_than_or_equal_to => 1,
                            :less_than_or_equal_to => MAX_ELEMENT_COUNT
  validates_presence_of     :title
  
  def self.max_element_count
    MAX_ELEMENT_COUNT
  end
  
  # Returns 
  # Returns array of month in which articles exists 
  def data(records)
    target_folder = self.folder || records[:folder]
    return [] unless target_folder
    target_folder.articles.recently_updated_ym(self.element_count)
  end
  
  private
  
  def set_default!
    if new_record?
      self.title = self.class.model_name.human
      self.element_count = 5
    end
    true
  end

  def self.accessible_attributes
    [:element_count, :folder_id, :title]    
  end
                                        
end
