class RenamePageIdToContentIdToPagesSetups < ActiveRecord::Migration
  def change
    rename_column :pages_setups, :page_id, :content_id
    rename_column :page_images, :page_id, :content_id
    rename_column :page_layouts_setups, :page_layout_id, :layout_id
  end
end
