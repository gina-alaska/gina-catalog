class CreatePortalUrls < ActiveRecord::Migration
  def change
    create_table :portal_urls do |t|
      t.integer :portal_id
      t.string :url
      t.boolean :default, default: false

      t.timestamps
    end
  end
end
