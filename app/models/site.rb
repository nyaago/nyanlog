class Site < ActiveRecord::Base
  
  after_create  :create_menus!
  before_create :set_theme!
  
  has_many    :folders, :dependent => :nullify
  has_many    :users
  has_many    :menus
  has_many    :widget_sets
  has_one     :header_menu,  :conditions => ["menu_type = ?", 'Header']
  has_one     :footer_menu,  :conditions => ["menu_type = ?", 'Footer']
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
  
  private
  
  def create_menus!
    Menu.create(:site => self, :menu_type => 'Header')
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

