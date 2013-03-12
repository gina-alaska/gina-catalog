class CreateMembershipRoles < ActiveRecord::Migration
  def change
    create_table :membership_roles do |t|
      t.integer :membership_id
      t.integer :role_id

      t.timestamps
    end
  end
end
