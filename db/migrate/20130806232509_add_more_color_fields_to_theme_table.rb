class AddMoreColorFieldsToThemeTable < ActiveRecord::Migration
  def change
    add_column :themes, :header_bg_grad, :string
    add_column :themes, :menu_bg_grad, :string
    add_column :themes, :footer_bg_grad, :string
  end
end
