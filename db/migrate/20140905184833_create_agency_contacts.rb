class CreateAgencyContacts < ActiveRecord::Migration
  def change
    create_table :agency_contacts do |t|
      t.integer :contact_id
      t.integer :agency_id

      t.timestamps
    end
  end
end
