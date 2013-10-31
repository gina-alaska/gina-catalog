class AddMoreSocialLinksToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :google_plus_url, :string
    add_column :setups, :youtube_url, :string
    add_column :setups, :instagram_url, :string
    add_column :setups, :linkedin_url, :string
  end
end
