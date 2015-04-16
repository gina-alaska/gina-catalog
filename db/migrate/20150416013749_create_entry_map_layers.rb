class CreateEntryMapLayers < ActiveRecord::Migration
  def change
    create_table :entry_map_layers do |t|
      t.references :entry, index: true
      t.references :map_layer, index: true

      t.timestamps null: false
    end
    add_foreign_key :entry_map_layers, :entries
    add_foreign_key :entry_map_layers, :map_layers
  end
end
