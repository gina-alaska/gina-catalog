class AddAcronymToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :acronym, :string
  end
end
