class AddActivityLogIdToContactInfos < ActiveRecord::Migration
  def change
    add_column :contact_infos, :activity_log_id, :integer
  end
end
