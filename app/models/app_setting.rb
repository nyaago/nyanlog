class AppSetting < ActiveRecord::Base
  
  belongs_to :default_site, :class_name => 'Site'
  
  
  def self.setting
    order('id asc').first
  end
  
  
end
