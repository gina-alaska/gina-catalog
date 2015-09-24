class AddRedirectUrlToCmsPages < ActiveRecord::Migration
  def change
    add_column :cms_pages, :redirect_url, :string
  end
end
