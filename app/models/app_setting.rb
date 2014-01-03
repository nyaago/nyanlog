class AppSetting < ActiveRecord::Base
  

  belongs_to :default_site, :class_name => 'Site'
  
  
  def self.accessible_attributes
    [:default_site_id]
  end

  def self.setting
    order('id asc').first
  end
  
  
end
