module DownloadActivityExtension
  def record_download!(contact_info = nil, user = nil, setup = nil)
    log = create({ activity: 'Download', user: user, log: { contact_info: contact_info.try(:id), setup_id: setup.try(:id) } })
    contact_info.try(:save, validate: false)
    log
  end 
  
  def downloads
    where(activity: 'Download')
  end
end