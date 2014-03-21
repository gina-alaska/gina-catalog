class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :name
      t.integer :catalog_id
      t.string :file_uid
      t.integer :file_size
      t.string :file_name
      t.boolean :downloadable
      t.boolean :preview
      t.string :uuid

      t.timestamps
    end
  end
end
