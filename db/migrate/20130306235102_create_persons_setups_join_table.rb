class CreatePersonsSetupsJoinTable < ActiveRecord::Migration
  def change
    create_table :persons_setups, id: false do |t|
      t.integer :people_id
      t.integer :setup_id
    end
    
    add_index :persons_setups, :setup_id
    add_index :persons_setups, :people_id
    add_index :persons_setups, [:setup_id, :people_id]
  end
end
