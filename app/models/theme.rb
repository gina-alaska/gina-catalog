class Theme < ActiveRecord::Base
  attr_accessible :content_bg, :header_bg, :header_color, :header_textcolor, :menu_active_bg, :menu_active_linkcolor, :menu_bg, :menu_hover_bg, :menu_hover_linkcolor, :menu_linkcolor, :name, :page_bg
end
