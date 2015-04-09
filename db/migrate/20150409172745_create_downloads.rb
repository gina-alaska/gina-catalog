class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.date :download_date
      t.integer :user
      t.text :useragent
      t.string :type

      t.timestamps null: false
    end
  end
end
