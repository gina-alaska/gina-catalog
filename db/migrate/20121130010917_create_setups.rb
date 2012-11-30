class CreateSetups < ActiveRecord::Migration
  def change
    create_table :setups do |t|
      t.string :primary_color
      t.string :title
      t.string :by_line
      t.string :url
      t.string :logo_uid

      t.timestamps
    end
  end
end
