class NewArrivalWidget < ActiveRecord::Base

  attr_accessible :element_count, :folder_id, :title

  include Widget

  MAX_ELEMENT_COUNT = 20

  belongs_to :folder

  before_validation :set_default!

  validates_numericality_of :element_count, 
                            :greater_than_or_equal_to => 1,
                            :less_than_or_equal_to => 20
  validates_presence_of     :title

  def self.max_element_count
    MAX_ELEMENT_COUNT
  end

  # Returns the new arrival articles
  # == parameters 
  # * records - key => record identifier (symbol) , value => activerecord 
  #   The following records are included. 
  # ** folder
  # ** site
  # ** article | articles
  def data(records)
    target_folder = self.folder || records[:folder]
    return [] unless target_folder
    target_folder.articles.recently_updated(self.element_count)
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
