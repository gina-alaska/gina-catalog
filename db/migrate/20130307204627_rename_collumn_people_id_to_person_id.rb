class RenameCollumnPeopleIdToPersonId < ActiveRecord::Migration
  change_table :persons_setups do |t|
    t.rename :people_id, :person_id
  end
end
