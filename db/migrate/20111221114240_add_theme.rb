class AddTheme < ActiveRecord::Migration
  def up
    add_column(:sites, :theme_name, :string)
    add_column(:folders, :theme_name, :string)
  end

  def down
    remove_column(:sites, :theme_name)
    remove_column(:folders, :theme_name)
  end
end
