class CreateSocialNetworks < ActiveRecord::Migration
  def change
    create_table :social_networks do |t|
      t.integer :portal_id
      t.integer :social_network_config_id
      t.string :url
      t.boolean :valid_url, default: true

      t.timestamps
    end
  end
end
