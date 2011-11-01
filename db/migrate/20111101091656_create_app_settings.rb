class CreateAppSettings < ActiveRecord::Migration
  def change
    create_table :app_settings do |t|
      t.integer :default_site_id
      t.timestamps
    end
  end
end
