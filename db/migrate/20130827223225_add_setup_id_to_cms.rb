class AddSetupIdToCms < ActiveRecord::Migration
  def up
    add_column :page_contents, :setup_id, :integer
    add_column :page_snippets, :setup_id, :integer
    add_column :page_layouts, :setup_id, :integer
    
    Page::Content.all.each do |c|
      c.setup_id = c.setups.first.id unless c.setups.empty?
      c.save!
    end
    Page::Snippet.all.each do |c|
      c.setup_id = c.setups.first.id unless c.setups.empty?
      c.save!
    end
    Page::Layout.all.each do |c|
      c.setup_id = c.setups.first.id unless c.setups.empty?
      c.save!
    end
  end
  
  def down
    remove_column :page_contents, :setup_id
    remove_column :page_snippets, :setup_id
    remove_column :page_layouts, :setup_id
  end
end
