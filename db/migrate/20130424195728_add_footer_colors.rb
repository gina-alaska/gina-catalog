class AddFooterColors < ActiveRecord::Migration
  def up
    add_column :themes, :footer_bg, :string
    add_column :themes, :footer_text_color, :string
    add_column :themes, :footer_partners_bg, :string
    
    Theme.update_all(footer_bg: '#343434', footer_text_color: '#DDD', footer_partners_bg: '#fff')
  end

  def down
    remove_column :themes, :footer_bg         
    remove_column :themes, :footer_text_color 
    remove_column :themes, :footer_partners_bg
  end
end
