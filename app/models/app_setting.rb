class AppSetting < ActiveRecord::Base
  
  attr_accessible :default_site_id

  belongs_to :default_site, :class_name => 'Site'
  
  
  def self.setting
    order('id asc').first
  end
  
  
end
