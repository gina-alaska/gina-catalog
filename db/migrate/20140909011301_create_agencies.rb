class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :name
      t.string :category
      t.string :description
      t.string :acronym, limit: 15
      t.boolean :active, default: true
      t.string :adiwg_code
      t.string :adiwg_path
      t.string :logo_uid
      t.string :logo_name
      t.string :url
      t.integer :parent_id

      t.timestamps
    end
  end
end
