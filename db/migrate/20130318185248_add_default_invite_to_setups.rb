class AddDefaultInviteToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :default_invite, :text
  end
end
