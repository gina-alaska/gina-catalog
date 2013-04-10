class CreateCatalogsContactsJoinTable < ActiveRecord::Migration
  def up
    create_table :catalogs_contacts do |t|
      t.integer :catalog_id
      t.integer :person_id

      t.timestamps
    end

    add_index :catalogs_contacts, :catalog_id
    add_index :catalogs_contacts, :person_id
    add_index :catalogs_contacts, [:person_id, :catalog_id]


    Catalog.all.each { |c| c.contacts = c.people }
  end

  def down
    drop_table :catalogs_contacts
  end
end
