class AddRecordProjectionToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :record_projection, :string
  end
end
