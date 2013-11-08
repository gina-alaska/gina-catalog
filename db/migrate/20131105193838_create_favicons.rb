class CreateFavicons < ActiveRecord::Migration
  def change
    create_table :favicons do |t|
      t.integer :setup_id
      t.string :image_uid
      t.string :image_name

      t.timestamps
    end
  end
end
