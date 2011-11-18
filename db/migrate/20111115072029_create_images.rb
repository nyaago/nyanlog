class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :folder
      t.string  :title
      t.string  :alternative
      t.text    :description
      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size
      t.integer :order_of_display
      t.datetime  :opened_at
      t.datetime  :closed_at
      t.integer :created_by_id
      t.integer :updated_by_id
      t.timestamps
    end
  end
end
