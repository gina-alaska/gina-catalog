class CreateEntryContacts < ActiveRecord::Migration
  def change
    create_table :entry_contacts do |t|
      t.integer :contact_id
      t.integer :entry_id
      t.boolean :primary

      t.timestamps
    end
  end
end
