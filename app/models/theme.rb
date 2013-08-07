class Theme < ActiveRecord::Base
  attr_accessible :name, :page_bg, :content_bg, :header_bg, :header_bg_grad,
    :header_title_color, :header_byline_color,
    :menu_bg, :menu_bg_grad, :menu_link_color, :menu_active_bg, :menu_active_link_color, 
    :menu_hover_bg, :menu_hover_link_color, :home_btn_bg, :home_btn_link_color, 
    :home_btn_hover_bg, :home_btn_hover_link_color, :home_btn_hover_border,
    :social_icons_link_color, :social_icons_hover_link_color, 
    :footer_bg, :footer_bg_grad, :footer_text_color, :footer_partners_bg, :css
  
  belongs_to :owner_setup, class_name: "Setup"
end
