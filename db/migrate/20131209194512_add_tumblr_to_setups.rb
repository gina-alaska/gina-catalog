class AddTumblrToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :tumblr_url, :string
  end
end
