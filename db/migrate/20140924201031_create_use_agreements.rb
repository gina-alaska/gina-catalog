class CreateUseAgreements < ActiveRecord::Migration
  def change
    create_table :use_agreements do |t|
      t.string :title
      t.text :body
      t.boolean :required, default: true
      t.integer :portal_id

      t.timestamps
    end
  end
end
