module DownloadActivityExtension
  def record_download!(download, user = nil, setup = nil)
    create({ activity: 'Download', user: user, log: { setup_id: setup.try(:id), url: download.url } })
  end 
  
  def downloads
    where(activity: 'Download')
  end
end