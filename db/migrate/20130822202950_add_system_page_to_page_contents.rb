class AddSystemPageToPageContents < ActiveRecord::Migration
  def change
    add_column :page_contents, :system_page, :boolean
  end
end
