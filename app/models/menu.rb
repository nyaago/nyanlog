class Menu < ActiveRecord::Base
  
  belongs_to  :site
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  has_many    :menu_items

  validates_presence_of   :menu_type
  validates_inclusion_of  :menu_type, :in => %w(Header Footer)

  # Filters by menu type
  scope :by_menu_type, lambda { |menu_type| 
                                s = menu_type.to_s
                                if s.blank?
                                  where("1 = 2")
                                else
                                  where("menu_type = ?", s[0].upcase + s[1..-1].downcase)
                                end
  }
  
  
end
