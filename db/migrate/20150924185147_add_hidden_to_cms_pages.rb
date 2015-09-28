class AddHiddenToCmsPages < ActiveRecord::Migration
  def change
    add_column :cms_pages, :hidden, :boolean, default: false
  end
end
