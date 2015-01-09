class CreateSocialNetworkConfigs < ActiveRecord::Migration
  def change
    create_table :social_network_configs do |t|
      t.string :name
      t.string :icon

      t.timestamps
    end
  end
end
