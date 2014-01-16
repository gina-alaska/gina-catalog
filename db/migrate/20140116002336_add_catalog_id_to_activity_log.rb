class AddCatalogIdToActivityLog < ActiveRecord::Migration
  def change
    add_column :activity_logs, :catalog_id, :integer
  end
end
