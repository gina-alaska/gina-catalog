class AddDragonFlyToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :file_uid, :string
    add_column :agencies, :file_name, :string
  end
end
