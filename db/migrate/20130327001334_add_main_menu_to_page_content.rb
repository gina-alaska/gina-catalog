class AddMainMenuToPageContent < ActiveRecord::Migration
  def change
    add_column :page_contents, :main_menu, :boolean
  end
end
