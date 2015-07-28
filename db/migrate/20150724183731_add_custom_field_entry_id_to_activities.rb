class AddCustomFieldEntryIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :entry_id, :integer, index: true
  end
end
