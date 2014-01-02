class Site < ActiveRecord::Base
  
#  attr_accessible :name, :title, :default_folder_id, :side_widget_set_id
#  attr_accessible :theme_name

  after_create  :create_menus!
  after_create  :create_belongings!
  before_create :set_theme_name!
  
  has_many    :folders, :dependent => :nullify
  has_many    :users
  has_many    :menus
  has_many    :widget_sets
  has_one     :header_menu,  :conditions => ["menu_type = ?", 'Header']
  has_one     :footer_menu,  :conditions => ["menu_type = ?", 'Footer']
  has_one     :page_design, :dependent => :destroy
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  belongs_to  :default_folder, :class_name => 'Folder'
  belongs_to  :side_widget_set, :class_name => 'WidgetSet'
  
  scope :listing, order('updated_at desc')
  
  validates_presence_of   :name
  validates_presence_of   :title
  validates_uniqueness_of :name
  
  # Returns theme records (Design::Theme)
  def theme
    Design::Theme.array.find_by_name(self.theme_name || 'Default')
  end
  
  # Returns the active page design.
  # the self.page_design will be returned. 
  def active_page_design
    self.page_design
  end
  
  private
  
  def create_menus!
    menu = Menu.new
    menu.site = self
    menu.menu_type = 'Header'
    menu.save!(:validate => true)
  end

  def create_belongings!
    page_design = PageDesign.new
    page_design.site = self
    page_design.save!(:validate => true)
  end
  
  def set_theme_name!
    themes = Design::Theme.array
    self.theme_name = 
    if themes.find_by_name('Default')
      'Default';
    else
      if themes.size
        themes[0].name
      else
        nil
      end
    end
    true
  end
  
end

