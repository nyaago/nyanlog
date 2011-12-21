class AddSideWidgetSet < ActiveRecord::Migration
  def up
    add_column(:sites, :side_widget_set_id, :integer)
    add_column(:folders, :side_widget_set_id, :integer)
  end

  def down
    remove_column(:sites, :side_widget_set_id)
    remove_column(:folders, :side_widget_set_id)
  end
end
