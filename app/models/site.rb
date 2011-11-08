class Site < ActiveRecord::Base
  
  has_many    :folders, :dependent => :nullify
  has_many    :users
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  belongs_to  :default_folder, :class_name => 'Folder'
              
  scope :listing, order('updated_at desc')
  
  validates_presence_of   :name
  validates_presence_of   :title
  validates_uniqueness_of :name
  
end

