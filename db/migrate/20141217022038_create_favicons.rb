class CreateFavicons < ActiveRecord::Migration
  def change
    create_table :favicons do |t|
      t.integer :portal_id
      t.string :image_name
      t.string :image_uid

      t.timestamps
    end
  end
end
