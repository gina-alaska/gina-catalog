class RemoveSecondaryFromEntryContacts < ActiveRecord::Migration
  def change
    remove_column :entry_contacts, :secondary, :boolean
  end
end
