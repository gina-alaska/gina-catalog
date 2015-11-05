class CreateCmsThemes < ActiveRecord::Migration
  def change
    create_table :cms_themes do |t|
      t.references :portal, index: true
      t.string :name
      t.text :css
      t.string :slug

      t.timestamps null: false
    end
    add_index :cms_themes, :slug
    add_foreign_key :cms_themes, :portals
  end
end
