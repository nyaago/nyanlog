class CreateMonthlyWidgets < ActiveRecord::Migration
  def change
    create_table :monthly_widgets do |t|
      t.references  :folder
      t.string      :title
      t.integer     :element_count
      t.timestamps
    end
  end
end
