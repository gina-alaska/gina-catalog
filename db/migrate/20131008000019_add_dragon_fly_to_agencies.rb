class AddDragonFlyToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :logo_uid, :string
    add_column :agencies, :logo_name, :string
  end
end
