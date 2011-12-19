class CreateNewArrivalWidgets < ActiveRecord::Migration
  def change
    create_table :new_arrival_widgets do |t|
      t.references  :folder
      t.string      :title
      t.integer     :element_count
      t.timestamps
    end
  end
end
