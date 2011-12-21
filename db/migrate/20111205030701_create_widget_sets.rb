class CreateWidgetSets < ActiveRecord::Migration
  def change
    create_table :widget_sets do |t|
      t.references  :site
      t.string      :title
      t.integer :owner_id
      t.integer :created_by_id
      t.integer :updated_by_id
      t.timestamps
    end
  end
end
