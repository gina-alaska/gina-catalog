class AddStatusToCswImports < ActiveRecord::Migration
  def change
    add_column :csw_imports, :status, :string
  end
end
