class CreatePageSnippets < ActiveRecord::Migration
  def change
    create_table :page_snippets do |t|
      t.string :slug
      t.text :content

      t.timestamps
    end
  end
end
