class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :country
      t.string :state
      t.string :city
      t.string :zipcode
      t.integer :addressable_id
      t.string :addressable_type

      t.timestamps
    end
  end
end
