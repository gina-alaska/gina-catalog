class CreateUseAgreements < ActiveRecord::Migration
  def change
    create_table :use_agreements do |t|
      t.string :title
      t.text :content
      t.boolean :required, :default => true
      t.timestamps
    end
  end
end
