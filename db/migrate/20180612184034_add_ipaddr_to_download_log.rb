class AddIpaddrToDownloadLog < ActiveRecord::Migration 
  def change 
    add_column :download_logs, :ipaddr, :string 
  end 
end 