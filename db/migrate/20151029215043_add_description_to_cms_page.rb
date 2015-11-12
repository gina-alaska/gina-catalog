class AddDescriptionToCmsPage < ActiveRecord::Migration
  def change
    add_column :cms_pages, :description, :text
  end
end
