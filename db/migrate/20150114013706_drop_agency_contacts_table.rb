class DropAgencyContactsTable < ActiveRecord::Migration
  def change
    drop_join_table :agency, :contacts
  end
end
