class CreateSiteUrls < ActiveRecord::Migration
  def change
    create_table :site_urls do |t|
      t.integer :site_id
      t.string :url
      t.boolean :default, default: false

      t.timestamps
    end
  end
end
