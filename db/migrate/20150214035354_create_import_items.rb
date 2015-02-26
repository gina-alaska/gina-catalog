class CreateImportItems < ActiveRecord::Migration
  def change
    create_table :import_items do |t|
      t.integer :import_id
      t.integer :importable_id
      t.string :importable_type

      t.timestamps null: false
    end
  end
end
