class AddHiddenToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :hidden, :boolean, default: false
  end
end
