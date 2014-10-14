class CreateEntrySites < ActiveRecord::Migration
  def change
    create_table :entry_sites do |t|
      t.integer :entry_id
      t.integer :site_id
      t.boolean :owner

      t.timestamps
    end
  end
end
