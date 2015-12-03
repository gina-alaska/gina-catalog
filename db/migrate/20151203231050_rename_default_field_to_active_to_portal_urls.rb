class RenameDefaultFieldToActiveToPortalUrls < ActiveRecord::Migration
  def change
    rename_column :portal_urls, :default, :active
  end
end
