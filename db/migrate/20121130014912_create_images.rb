class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.string :description
      t.string :link_to_url
      t.string :file_uid

      t.timestamps
    end
    
    create_table :images_setups, id: false do |t|
      t.integer :setup_id
      t.integer :image_id
    end
  end
end
