class AddSecondaryToEntryContacts < ActiveRecord::Migration
  def change
    add_column :entry_contacts, :secondary, :boolean, default: false
  end
end
