class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.references  :menu
      t.references  :folder
      t.string      :title
      t.integer     :order_of_display
      t.integer     :parent_id
      t.integer     :created_by_id
      t.integer     :updated_by_id
      t.timestamps
    end
  end
end
