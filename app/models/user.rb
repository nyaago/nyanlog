# = User
# User model
class User < ActiveRecord::Base
  
  LEN_REISSUE_PASSWORD = 30
  
  belongs_to  :updated_by, :class_name => 'User',
              :foreign_key => 'updated_by_id'
  belongs_to  :created_by, :class_name => 'User',
              :foreign_key => 'created_by_id'
  belongs_to  :site
  has_many    :folders, :class_name => 'User',
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
