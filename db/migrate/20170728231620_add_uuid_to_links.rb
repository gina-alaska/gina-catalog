class AddUuidToLinks < ActiveRecord::Migration
  def change
    add_column :links, :uuid, :string
    add_index :links, :uuid, unique: true
  end
end
