class RemoveOldThemeTable < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :themes do |_t|
        dir.up { drop_table :themes }
        dir.down do
          create_table :themes do |t|
            t.string :name
            t.string :page_bg
            t.string :content_bg
            t.string :header_bg
            t.string :header_title_color
            t.string :header_byline_color
            t.string :header_bg_grad
            t.string :menu_bg
            t.string :menu_link_color
            t.string :menu_active_bg
            t.string :menu_active_link_color
            t.string :menu_hover_bg
            t.string :menu_hover_link_color
            t.string :menu_bg_grad
            t.string :home_btn_bg
            t.string :home_btn_link_color
            t.string :home_btn_hover_bg
            t.string :home_btn_hover_border
            t.string :home_btn_hover_link_color
            t.string :social_icons_link_color
            t.string :social_icons_hover_link_color
            t.string :footer_bg
            t.string :footer_text_color
            t.string :footer_partners_bg
            t.string :footer_bg_grad
            t.integer :owner_portal_id
            t.boolean :locked
            t.text :css

            t.timestamps null: false
          end
        end
      end
    end
  end
end
