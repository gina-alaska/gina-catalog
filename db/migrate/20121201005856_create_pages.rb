class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :slug
      t.string :sections
      t.text :content
      t.string :layout

      t.timestamps
    end
    
    create_table :pages_setups, id: false do |t|
      t.integer :setup_id
      t.integer :page_id
    end
  end
end
