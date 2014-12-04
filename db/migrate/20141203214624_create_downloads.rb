class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.string :name
      t.string :file_type
      t.string :url
      t.string :uuid
      t.integer :entry_id

      t.timestamps
    end
  end
end
