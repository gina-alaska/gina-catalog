class Theme < ActiveRecord::Base
  validates :name, length: { maximum: 255 }, presence: true
  validates :page_bg, length: { maximum: 255 }
  validates :content_bg, length: { maximum: 255 }
  validates :header_bg, length: { maximum: 255 }
  validates :header_title_color, length: { maximum: 255 }
  validates :header_byline_color, length: { maximum: 255 }
  validates :header_bg_grad, length: { maximum: 255 }
  validates :menu_bg, length: { maximum: 255 }
  validates :menu_link_color, length: { maximum: 255 }
  validates :menu_active_bg, length: { maximum: 255 }
  validates :menu_active_link_color, length: { maximum: 255 }
  validates :menu_hover_bg, length: { maximum: 255 }
  validates :menu_hover_link_color, length: { maximum: 255 }
  validates :menu_bg_grad, length: { maximum: 255 }
  validates :home_btn_bg, length: { maximum: 255 }
  validates :home_btn_link_color, length: { maximum: 255 }
  validates :home_btn_hover_bg, length: { maximum: 255 }
  validates :home_btn_hover_border, length: { maximum: 255 }
  validates :home_btn_hover_link_color, length: { maximum: 255 }
  validates :social_icons_link_color, length: { maximum: 255 }
  validates :social_icons_hover_link_color, length: { maximum: 255 }
  validates :footer_bg, length: { maximum: 255 }
  validates :footer_text_color, length: { maximum: 255 }
  validates :footer_partners_bg, length: { maximum: 255 }
  validates :footer_bg_grad, length: { maximum: 255 }

  belongs_to :owner_portal, class_name: 'Portal'
end
