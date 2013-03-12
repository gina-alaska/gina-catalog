class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.string :email
      t.integer :setup_id
      t.timestamps
    end
  end
end
