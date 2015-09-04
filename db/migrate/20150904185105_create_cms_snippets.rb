class CreateCmsSnippets < ActiveRecord::Migration
  def change
    create_table :cms_snippets do |t|
      t.string :name
      t.string :slug
      t.text :content
      t.references :portal, index: true

      t.timestamps null: false
    end
    add_foreign_key :cms_snippets, :portals
  end
end
