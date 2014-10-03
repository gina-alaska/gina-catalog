class AddLinkTemplateToCswImport < ActiveRecord::Migration
  def change
    add_column :csw_imports, :url_template, :string
    add_column :csw_imports, :url_description, :string
  end
end
