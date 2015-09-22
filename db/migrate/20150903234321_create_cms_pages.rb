class CreateCmsPages < ActiveRecord::Migration
  def change
    create_table :cms_pages do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.references :portal, index: true
      t.references :cms_layout, index: true

      t.timestamps null: false
    end
    add_index :cms_pages, :slug, unique: true
    add_foreign_key :cms_pages, :portals
    add_foreign_key :cms_pages, :cms_layouts
  end
end
