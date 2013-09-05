class AddSystemPageToPageSnippets < ActiveRecord::Migration
  def change
    add_column :page_snippets, :system_page, :boolean, default: false
  end
end
