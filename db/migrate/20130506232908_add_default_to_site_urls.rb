class AddDefaultToSiteUrls < ActiveRecord::Migration
  def change
    add_column :site_urls, :default, :boolean
  end
end
