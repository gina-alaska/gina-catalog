class RenameEntryAgenciesToEntryOrganizations < ActiveRecord::Migration
  def change
    rename_table :entry_agencies, :entry_organizations
  end
end
