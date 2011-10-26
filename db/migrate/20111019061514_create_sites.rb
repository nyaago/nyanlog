class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string  :name, :null => false
      t.string  :title
      t.text    :description
      t.date    :opend_at
      t.date    :closed_at
      t.boolean :not_in_public
      t.integer :created_by_id
      t.integer :updated_by_id
      t.timestamps
    end
  end
end
