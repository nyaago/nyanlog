class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string  :menu_type
      t.references  :site
      t.boolean :hidden
      t.integer     :created_by_id
      t.integer     :updated_by_id
      t.timestamps
    end
  end
end
