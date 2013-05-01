class AddMetadataFieldsToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :description, :text
    add_column :setups, :keywords, :text
  end
end
