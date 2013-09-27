class AddImageIdToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :image_id, :integer
  end
end
