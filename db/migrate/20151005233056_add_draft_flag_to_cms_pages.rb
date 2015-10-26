class AddDraftFlagToCmsPages < ActiveRecord::Migration
  def change
    add_column :cms_pages, :draft, :boolean, default: false
  end
end
