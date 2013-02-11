class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :setup_id
      t.string :name
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
