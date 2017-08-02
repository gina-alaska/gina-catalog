class CreateCmsPageHierarchies < ActiveRecord::Migration
  def change
    create_table :cms_page_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :cms_page_hierarchies, %i[ancestor_id descendant_id generations],
              unique: true,
              name: 'page_anc_desc_idx'

    add_index :cms_page_hierarchies, [:descendant_id],
              name: 'page_desc_idx'
  end
end
