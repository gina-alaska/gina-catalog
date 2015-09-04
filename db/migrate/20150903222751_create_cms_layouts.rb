class CreateCmsLayouts < ActiveRecord::Migration
  def change
    create_table :cms_layouts do |t|
      t.string :name
      t.string :slug
      t.references :portal, index: true
      t.text :content

      t.timestamps null: false
    end
    add_foreign_key :cms_layouts, :portals
  end
end
