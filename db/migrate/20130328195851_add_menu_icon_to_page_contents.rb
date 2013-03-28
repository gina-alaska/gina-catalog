class AddMenuIconToPageContents < ActiveRecord::Migration
  def change
    add_column :page_contents, :menu_icon, :string
  end
end
