class CreateCarouselImagesTable < ActiveRecord::Migration
  def change
    create_table :carousel_images_setups, id: false do |t|
      t.integer :setup_id
      t.integer :image_id
    end
  end
end
