class RenameAgenciesToOrganizations < ActiveRecord::Migration
  def change
    rename_table :agencies, :organizations
  end
end
