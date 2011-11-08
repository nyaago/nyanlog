class AddDefaultFolderToSite < ActiveRecord::Migration
  def change
    add_column(:sites, :default_folder_id, :integer)
    add_column(:users, :default_folder_id, :integer)
  end
end
