class AddHiddenToSiteUrls < ActiveRecord::Migration
  def change
    add_column :site_urls, :hidden, :boolean
  end
end
