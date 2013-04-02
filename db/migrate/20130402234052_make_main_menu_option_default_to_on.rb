class MakeMainMenuOptionDefaultToOn < ActiveRecord::Migration
  def up
    change_column :page_contents, :main_menu, :boolean, :default => true
  end

  def down
    change_column :page_contents, :main_menu, :boolean, :default => false
  end
end
