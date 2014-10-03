class AddSetupIdToActivityLog < ActiveRecord::Migration
  def up
    add_column :activity_logs, :setup_id, :integer
    add_column :activity_logs, :contact_info_id, :integer
    
    ActivityLog.all.each do |al|
      next if al.log.nil? or al.log[:setup_id].nil?
      al.update_attribute(:setup_id, al.log[:setup_id])
    end
  end
  
  def down
    remove_column :activity_logs, :setup_id
    remove_column :activity_logs, :contact_info_id
  end
end
