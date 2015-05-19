class RemoveDataTypeIdFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :data_type_id, :integer
  end
end
