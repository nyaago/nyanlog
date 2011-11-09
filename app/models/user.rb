# = User
# User model
class User < ActiveRecord::Base
  
  LEN_REISSUE_PASSWORD = 30
  
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  belongs_to  :site
  belongs_to  :default_folder, :class_name => 'Folder',
              :foreign_key => 'default_folder_id'
  has_many    :folders, :class_name => 'Folder',
              :foreign_key => 'owner_id'
  # filtering by the user
  scope :filter_by_user, lambda { |user|
    unless user.is_admin
      where("site_id = ?", user.site_id)
    end
  }
  # filtering by the site
  scope :filter_by_site, lambda { |site|
    if site
      where("site_id = ?", if site.respond_to?(:id);site_id;else;site;end)
    end
  }
  # listing
  scope :listing, order('login')
  # only administrators
  scope :administrators, where("is_admin = true")
  # site administrators
  scope :site_administrators, lambda { |site| where("site_id = ? AND is_site_admin = true", site.id) }
  # users who can administer  the site (administrators and site administrators)
  scope :site_administable, lambda { |site| 
          where("is_admin = true OR  site_id = ? AND is_site_admin = true", site.id) }
  # site editors
  scope :editors, lambda { |site| where("site_id = ? AND is_editor = true", site.id) }
  # users who can edit  the site (administrators and site administrators and site editors)
  scope :editable, lambda { |site| 
          where("is_admin = true OR site_id = ? AND (is_site_admin = true or is_editor = true)",
          site.id) }
  # users belonging to a site 
  scope :site_belongs_to, lambda { |site| where("site_id = ?", site.id) }
  # users who can own folders of the site(administrator and users belonging to the site )
  scope :can_own_folder_of, lambda { |site| 
          where("site_id = ? OR is_admin = ?", site.id, true) }
  
  validates_presence_of :site_id, :unless => Proc.new { |user| user.is_admin }
  
  
  # 認証を行うモデルとしての拡張
  acts_as_authentic do |config|
    #
    #
    config.crypto_provider = Authlogic::CryptoProviders::MD5
    config.maintain_sessions = true
  end
  
  # whether the user can manage users
  def can_manage_users?
    is_admin || is_site_admin
  end

  # whether the user can manage users
  def can_manage_user?(user)
    is_admin || (is_site_admin && self.site_id == user.site_id)
  end
  
  # whether the user can manage site
  def can_manage_site?(site)
    is_admin || (site && is_site_admin && self.site_id == site.id)
  end

  # whether the user can manage site
  def can_edit_folder?(folder)
    site = folder.site
    is_admin || (site && (is_site_admin || is_editor) && self.site_id == site.id) ||
    self == folder.owner 
  end
  
  # return folders which the user can edit.
  def editable_folders(current_site = nil)
    @editable_folders ||=
    if is_admin
      if current_site
        current_site.folders
      else
        []
      end
    elsif is_site_admin || is_editor
      if current_site && current_site != self.site
        []
      else
        site.folders
      end
    else
      folders
    end
  end
  
  # Generates a password for  reissuing a password.
  def generate_reissue_password
    src_str = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a

    password = nil
    begin
      password = String.new
      LEN_REISSUE_PASSWORD.times {
      	random_num = rand(src_str.length)
      	password += src_str[random_num].chr
      }
    end while User.select('id').
    where("reissue_password = :reissue_password", :reissue_password => password).size > 0
    self.reissue_password = password
  end
  
end
