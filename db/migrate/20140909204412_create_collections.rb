class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name
      t.string :description
      t.integer :portal_id
      t.boolean :hidden

      t.timestamps
    end
  end
end
