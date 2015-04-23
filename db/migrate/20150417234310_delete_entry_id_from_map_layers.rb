class DeleteEntryIdFromMapLayers < ActiveRecord::Migration
  def change
    change_table :map_layers do |t|
      t.remove :entry_id
    end
  end
end
