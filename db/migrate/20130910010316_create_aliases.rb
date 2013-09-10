class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.string :text
      t.references :aliasable, polymorphic: true
      
      t.timestamps
    end
  end
end
