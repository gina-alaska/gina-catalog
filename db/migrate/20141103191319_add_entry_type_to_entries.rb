class AddEntryTypeToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :entry_type_id, :integer
  end
end
