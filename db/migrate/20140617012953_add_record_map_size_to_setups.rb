class AddRecordMapSizeToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :record_map_size, :string, default: "normal"
  end
end
