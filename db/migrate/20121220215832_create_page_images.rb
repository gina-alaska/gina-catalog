class CreatePageImages < ActiveRecord::Migration
  def change
    create_table :page_images do |t|
      t.integer :image_id
      t.integer :page_id

      t.timestamps
    end
  end
end
