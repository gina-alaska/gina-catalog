class CreateEntryTypes < ActiveRecord::Migration
  def change
    create_table :entry_types do |t|
      t.string :name
      t.string :description
      t.string :color

      t.timestamps
    end
  end
end
