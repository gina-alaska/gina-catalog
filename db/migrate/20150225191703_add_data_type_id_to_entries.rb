class AddDataTypeIdToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :data_type_id, :integer
  end
end
