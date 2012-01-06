class CreatePageDesigns < ActiveRecord::Migration
  def change
    create_table :page_designs do |t|
      t.references  :site
      t.references  :folder
      t.text        :stylesheet
      t.string      :header_image_file_name
      t.string      :header_image_content_type
      t.integer     :header_image_file_size
      t.string      :header_color, :limit => 10
      t.string      :background_color,  :limit => 10
      t.string      :background_image_file_name
      t.string      :background_image_content_type
      t.integer     :background_image_file_size
      t.string      :background_position # left, center, right
      t.string      :background_repeat # repeat-x, repeat-y, repeat, no-repeat
      t.string      :background_attachment # fixed, scroll
      t.boolean     :background_interited_from_site, :default => true
      t.text        :footer_html
      t.text        :header_html
      t.timestamps
    end
  end
end
