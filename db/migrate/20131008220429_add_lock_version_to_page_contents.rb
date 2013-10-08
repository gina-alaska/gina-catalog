class AddLockVersionToPageContents < ActiveRecord::Migration
  def change
    add_column :page_contents, :lock_version, :integer
    add_column :page_layouts, :lock_version, :integer
    add_column :page_snippets, :lock_version, :integer
  end
end
