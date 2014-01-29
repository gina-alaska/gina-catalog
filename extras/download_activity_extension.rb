module DownloadActivityExtension
  def record_download!(contact_info = nil, current_user = nil)
    create({ activity: 'Download', log: { contact_info: contact_info.try(:id), user_id: current_user.try(:id) } })
  end 
  
  def downloads
    where(activity: 'Download')
  end
end