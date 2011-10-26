class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :site
      t.string :login,              :null => false
      t.string :email,              :null => false
      t.string :persistence_token , :null => false
      t.string :crypted_password,   :null => false
      t.string :password_salt,      :null => false
      t.string :single_access_token,:null => false
      t.integer :login_count,       :null => false, :default => 0
      t.integer :failed_login_count,:null => false, :default => 0
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.datetime :last_request_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.boolean :auto_login
      t.boolean :is_admin
      t.boolean :is_site_admin
      t.boolean :is_editor
      t.integer :created_by_id
      t.integer :updated_by_id
      t.timestamps
    end
  end
end
