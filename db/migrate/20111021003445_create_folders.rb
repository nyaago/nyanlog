class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.references :site
      t.string  :name
      t.string  :title
      t.text    :description
      t.datetime  :opened_at
      t.datetime  :closed_at
      t.string  :ordering_type, :default => 'ByCreatedAtDesc' , :null => false 
                # ByCreatedAtDesc, ByUpdatedAtDesc, ByCreatedAtAsc, ByCreatedAtDesc .. 
      t.integer :article_count_by_page, :default => 10
      t.integer :owner_id
      t.integer :created_by_id
      t.integer :updated_by_id
      t.timestamps
    end
  end
end
