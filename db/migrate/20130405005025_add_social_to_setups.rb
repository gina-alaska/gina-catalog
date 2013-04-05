class AddSocialToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :twitter_url, :string
    add_column :setups, :github_url, :string
    add_column :setups, :facebook_url, :string
  end
end
