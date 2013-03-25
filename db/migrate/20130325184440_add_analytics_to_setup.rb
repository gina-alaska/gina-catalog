class AddAnalyticsToSetup < ActiveRecord::Migration
  def change
    add_column :setups, :analytics_account, :text
  end
end
