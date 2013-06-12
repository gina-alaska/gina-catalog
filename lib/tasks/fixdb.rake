namespace :fixdb do
  desc 'run all fixdb tasks'
  task :all => [:collections, :themes, :update_downloads] do
  end
  
  desc 'migrate collections to the new setup'
  task :collections => :environment do
    puts "Looking for collections to migrate"
    
    CatalogCollection.all.each do |cc|
      next if Collection.where(name: cc.name).count > 0
      puts "Creating new collection for #{cc.name}"
      c = Collection.new({ name: cc.name, description: cc.description, setup_id: cc.setup_id })
      c.catalogs = cc.catalogs
      c.save!
    end
  end
    
  desc 'assign default themes to any setup that is missing one'
  task :themes => :environment do
    puts "Looking for setups with missing themes"
    
    default = Theme.where(name: 'Default').first
    
    Setup.where(:theme_id => nil).all.each do |s|
      next unless s.theme.nil?
      puts "Fixing theme for #{s.title}"
      s.theme = default
      s.save!
    end
  end

  desc 'copy all download links and add them as download_urls'
  task :update_downloads => :environment do
    puts "Looking for download links to copy..."
    
    Catalog.all.each do |item|
      curlinks = item.links.where(category: "Download").all
      next if curlinks.nil?

      curlinks.each do |link|
        if item.download_urls.where(url: link.url).empty?
          puts "Creating new download URL: #{link.display_text} - #{link.url}"
          item.download_urls << DownloadUrl.new(name: link.display_text, url: link.url)
          item.save
        end
      end
    end
  end
end