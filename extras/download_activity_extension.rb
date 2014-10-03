module DownloadActivityExtension
  def record_download!(contact_info, catalog, user = nil, setup = nil)
    downloads.create({ 
      catalog: catalog, 
      contact_info: contact_info, 
      user: user, 
      setup: setup, 
      log: { name: proxy_association.owner.to_s } 
    })
  end 
  
  def downloads
    where(activity: 'Download')
  end
end