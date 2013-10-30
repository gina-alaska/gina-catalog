class AddFaviconToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :favicon_uid, :string
    add_column :setups, :favicon_name, :string
  end
end
