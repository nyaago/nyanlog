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
  
  # 認証を行うモデルとしての拡張
  acts_as_authentic do |config|
    #
    #
    config.crypto_provider = Authlogic::CryptoProviders::MD5
    config.maintain_sessions = true
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
