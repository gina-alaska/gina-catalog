class AddGlobalToPageContents < ActiveRecord::Migration
  def change
    add_column :page_contents, :global, :boolean, default: false
  end
end
