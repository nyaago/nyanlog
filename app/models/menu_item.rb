class MenuItem < ActiveRecord::Base
  
  ERROR_TRANSLATION_SCOPE = [:errors, :menu_item, :messages]
  
  MAX_HIERARCHY = 3
  
  include ::Attribute::OrderOfDisplay
  
  #
  acts_as_tree
  
  #
  # Attribute::OrderOfDisplay::StaticMethods.parent_attrs
  parent_attrs  :menu_id, :parent_id
  # Attribute::OrderOfDisplay::StaticMethods.ordered_by_specification_always
  ordered_by_specification_always true
  
  # set the order of display (Attribute::OrderOfDisplay.set_order_of_display!)
  before_create :set_order_of_display!
  
  #
  belongs_to  :menu
  belongs_to  :folder
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  
  #
  scope   :listing, order("order_of_display")
  # Filtering by id
  scope   :by_id, lambda { |id| where("id = ?", id)  } 
  # Filtering by parent
  scope   :by_parent, lambda { |parent|
                      if parent
                        where("parent_id = ?", if respond_to?(:id);parent.id;else;parent;end) 
                      else
                        where("parent_id IS NULL")
                      end }
                        
  #
  validates_presence_of :menu_id
  # The site of the menu  must be equals to the site of the folder 
  validate  :site_of_menu_must_equals_to_site_of_folder
  # The tree must not be looped
  validate  :tree_must_not_loop
  # The depth of the hierarchy of the tree must not be beyond the limited value.
  validate  :hierarchy_must_not_beyond_limit
  #
  validate  :presence_of_folder_or_title

  # the title for display (self.title or self.folder.title)
  def title_for_display
    if !title.blank?
      title
    elsif folder
      folder.title || ''
    else
      ''
    end
  end
  
  # Returns the depth of the tree hierarchy
  def hierarchy_depth
    def hierarchy_depth_recursive(count, cur)
      return count if cur.nil?
      return hierarchy_depth_recursive(count + 1, cur.parent)
    end
    hierarchy_depth_recursive(0,self)
  end
  
  # Is the depth of the tree hierarchy the max or beyond the max?
  def max_depth?
    hierarchy_depth >= MAX_HIERARCHY
  end

  # Is the depth of the tree hierarchy  beyond the max?
  def beyond_depth?
    hierarchy_depth > MAX_HIERARCHY
  end
  
  # Returns the number of children elements.
  def children_count
    children.count
  end
    
  # Is the tree looped?
  def tree_looped?
    def tree_looped_recursive?(target, cur)
      return false if cur.nil?
      return true if target == cur
      return tree_looped_recursive?(target, cur.parent)
    end
    tree_looped_recursive?(self, self.parent)
  end
  
  #
  def self.max_depth
    MAX_HIERARCHY
  end
  
  private
  
  # The site of the menu  must be equals to the site of the folder 
  def site_of_menu_must_equals_to_site_of_folder
    if folder && menu
      if folder.site != menu.site
        errors.add(:base, I18n.t(:site_of_menu_must_equals_to_site_of_folder, 
                                  :scope => ERROR_TRANSLATION_SCOPE) )
      end
    end
  end
  
  # The tree must not be looped
  def tree_must_not_loop
    if tree_looped?
      errors.add(:base, I18n.t(:tree_must_not_loop, 
                                :scope => ERROR_TRANSLATION_SCOPE) )
    end
  end
  
  # The depth of the hierarchy of the tree must not be beyond the limited value.
  def hierarchy_must_not_beyond_limit
    if hierarchy_depth > MAX_HIERARCHY
      errors.add(:base, I18n.t(:must_not_beyond_limited_hierarchy, 
                                :scope => ERROR_TRANSLATION_SCOPE,
                                :count => MAX_HIERARCHY) )
    end
  end
  
  #
  def presence_of_folder_or_title
    if title.blank? && folder_id.blank?
      errors.add(:base, I18n.t(:presence_of_folder_or_title, 
                                :scope => ERROR_TRANSLATION_SCOPE) )
    end
  end
  
end
