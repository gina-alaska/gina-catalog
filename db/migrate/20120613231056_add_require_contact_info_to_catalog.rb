class AddRequireContactInfoToCatalog < ActiveRecord::Migration
  def change
    add_column :catalog, :request_contact_info, :boolean, :default => false
    add_column :catalog, :require_contact_info, :boolean, :default => false
  end
end
