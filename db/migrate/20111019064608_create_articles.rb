class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.references :folder
      t.string  :title
      t.text    :content
      t.integer :order_of_display
      t.datetime  :opened_at
      t.datetime  :closed_at
      t.integer :created_by_id
      t.integer :updated_by_id
      t.timestamps
    end
  end
end
