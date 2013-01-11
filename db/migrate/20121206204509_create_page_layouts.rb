class CreatePageLayouts < ActiveRecord::Migration
  def change
    create_table :page_layouts do |t|
      t.string :name
      t.text :content

      t.timestamps
    end
    
    create_table :page_layouts_setups, id: false do |t|
      t.integer :setup_id
      t.integer :page_layout_id
    end
  end
end
