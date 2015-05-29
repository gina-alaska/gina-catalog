class CreateEntryDataTypes < ActiveRecord::Migration
  def change
    create_table :entry_data_types do |t|
      t.integer :data_type_id
      t.integer :entry_id

      t.timestamps
    end
  end
end
