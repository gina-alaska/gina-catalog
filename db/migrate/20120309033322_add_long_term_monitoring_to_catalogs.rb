class AddLongTermMonitoringToCatalogs < ActiveRecord::Migration
  def change
    add_column :catalog, :long_term_monitoring, :boolean
  end
end
