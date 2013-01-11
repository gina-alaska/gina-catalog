class AddDefaultToPageLayouts < ActiveRecord::Migration
  def change
    add_column :page_layouts, :default, :boolean
  end
end
