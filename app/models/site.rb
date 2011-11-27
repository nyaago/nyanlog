class Site < ActiveRecord::Base
  
  after_create  :create_menus!
  
  has_many    :folders, :dependent => :nullify
  has_many    :users
  has_many    :menus
  has_one     :header_menu,  :conditions => ["menu_type = ?", 'Header']
  has_one     :footer_menu,  :conditions => ["menu_type = ?", 'Footer']
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  belongs_to  :default_folder, :class_name => 'Folder'
              
  scope :listing, order('updated_at desc')
  
  validates_presence_of   :name
  validates_presence_of   :title
  validates_uniqueness_of :name
  
  private
  
  def create_menus!
    Menu.create(:site => self, :menu_type => 'Header')
  end
  
end

