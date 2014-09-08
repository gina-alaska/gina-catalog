class CreateEntryAgencies < ActiveRecord::Migration
  def change
    create_table :entry_agencies do |t|
      t.integer :entry_id
      t.integer :agency_id
      t.boolean :primary, default: false
      t.boolean :funding, default: false

      t.timestamps
    end
  end
end
