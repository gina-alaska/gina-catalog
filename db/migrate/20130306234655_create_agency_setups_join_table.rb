class CreateAgencySetupsJoinTable < ActiveRecord::Migration
  def change
    create_table :agencies_setups, id: false do |t|
      t.integer :agency_id
      t.integer :setup_id
    end
    
    add_index :agencies_setups, :setup_id
    add_index :agencies_setups, :agency_id
    add_index :agencies_setups, [:agency_id, :setup_id]
  end
end
