module DownloadActivityExtension
  def record_download!(contact_info = nil, current_user = nil)
    log = create({ activity: 'Download', log: { user_id: current_user.try(:id) } })
    if contact_info
      contact_info.activity_log = log
      contact_info.save
    end
    
    log
  end 
  
  def downloads
    where(activity: 'Download')
  end
end