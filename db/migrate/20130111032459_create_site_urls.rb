class CreateSiteUrls < ActiveRecord::Migration
  def change
    create_table :site_urls do |t|
      t.string :url
      t.integer :setup_id

      t.timestamps
    end
    
    add_index :site_urls, :url
  end
end
