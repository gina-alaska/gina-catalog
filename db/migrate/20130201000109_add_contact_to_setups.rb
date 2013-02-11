class AddContactToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :contact_email, :string
  end
end
