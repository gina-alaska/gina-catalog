class CreateDownloadUrls < ActiveRecord::Migration
  def change
    create_table :download_urls do |t|
      t.string    :name
      t.string    :file_type
      t.string    :url
      t.integer   :catalog_id
      t.string    :uuid
      t.timestamps
    end
  end
end
