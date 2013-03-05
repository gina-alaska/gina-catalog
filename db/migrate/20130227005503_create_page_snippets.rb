class CreatePageSnippets < ActiveRecord::Migration
  def change
    create_table :page_snippets do |t|
      t.string :slug
      t.text :content

      t.timestamps
    end
    add_index :page_snippets, :slug
    
    create_table :setups_snippets, id: false do |t|
      t.integer :setup_id
      t.integer :snippet_id
    end
    
    add_index :setups_snippets, :setup_id
    add_index :setups_snippets, :snippet_id
    add_index :setups_snippets, [:setup_id, :setup_id]
  end
end
