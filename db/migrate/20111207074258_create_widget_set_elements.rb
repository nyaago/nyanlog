class CreateWidgetSetElements < ActiveRecord::Migration
  def change
    create_table :widget_set_elements do |t|
      t.references  :widget_set
      t.references  :widget
      t.string      :widget_type
      t.integer     :order_of_display
      t.timestamps
    end
  end
end
