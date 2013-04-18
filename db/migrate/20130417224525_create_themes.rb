class CreateThemes < ActiveRecord::Migration
  def up
    create_table :themes, force: true do |t|
      t.string :name
      t.string :page_bg
      t.string :content_bg
      t.string :header_bg
      t.string :header_title_color
      t.string :header_byline_color
      t.string :menu_bg
      t.string :menu_link_color
      t.string :menu_active_bg
      t.string :menu_active_link_color
      t.string :menu_hover_bg
      t.string :menu_hover_link_color
      t.string :home_btn_bg
      t.string :home_btn_link_color
      t.string :home_btn_hover_bg
      t.string :home_btn_hover_border
      t.string :home_btn_hover_link_color
      t.string :social_icons_link_color
      t.string :social_icons_hover_link_color
      t.boolean :locked, default: false
      t.timestamps
    end
    add_column :setups, :theme_id, :integer
    
    default = Theme.create do |t|
      t.name                    = 'Default'
      t.locked                  = true
      t.page_bg                 = '#dadada'
      t.content_bg              = '#fff'
      t.header_bg               = 'hsl(92,79%,24%)'
      t.header_title_color      = '#fff'
      t.header_byline_color     = '#fff'
      t.menu_bg                 = 'hsl(92,79%,20%)'
      t.menu_link_color         = '#fff'
      t.menu_active_bg          = 'hsl(92,79%,15%)'
      t.menu_active_link_color  = '#fff'
      t.menu_hover_bg           = '#efefef'
      t.menu_hover_link_color   = '#000'
      t.home_btn_bg             = 'rgba(110, 13, 37, 0.8)'
      t.home_btn_link_color     = '#fff'
      t.home_btn_hover_bg       = 'rgba(110, 13, 37, 1)'
      t.home_btn_hover_border   = '4px solid rgba(100, 3, 27, 1)'
      t.home_btn_hover_link_color= '#fff'
      t.social_icons_link_color = '#fff'
      t.social_icons_hover_link_color = '#0288CC'
    end
  end
  
  def down
    drop_table :themes
    remove_column :setups, :theme_id 
  end
end
