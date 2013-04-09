class AddOwnerSetupIdToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalog, :owner_setup_id, :integer
  end
end
