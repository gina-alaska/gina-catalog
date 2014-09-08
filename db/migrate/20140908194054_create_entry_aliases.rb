class CreateEntryAliases < ActiveRecord::Migration
  def change
    create_table :entry_aliases do |t|
      t.string :slug
      t.integer :entry_id

      t.timestamps
    end
  end
end
