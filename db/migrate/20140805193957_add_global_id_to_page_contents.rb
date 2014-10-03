class AddGlobalIdToPageContents < ActiveRecord::Migration
  def change
    add_column :page_contents, :global_id, :integer
  end
end
