class AddFgdcImportAttributes < ActiveRecord::Migration
  def change
    add_column :csw_imports, :metadata_field, :string, 
               :default => "urn:x-esri:specification:ServiceType:ArcIMS:Metadata:Document"
    add_column :csw_imports, :metadata_type, :string, :default => "FGDC"
    add_column :catalog, :remote_updated_at, :datetime
  end
end
