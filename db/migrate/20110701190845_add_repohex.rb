class AddRepohex < ActiveRecord::Migration
  def self.up
    add_column :catalog, :repohex, :string
  end

  def self.down
    remove_column :catalog, :repohex
  end
end
