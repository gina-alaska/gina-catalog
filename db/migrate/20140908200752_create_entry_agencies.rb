class CreateEntryAgencies < ActiveRecord::Migration
  def change
    create_table :entry_agencies do |t|
      t.integer :entry_id
      t.integer :agency_id
      t.boolean :primary
      t.boolean :funding

      t.timestamps
    end
  end
end
