class AddUrlToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :url, :string
  end
end
