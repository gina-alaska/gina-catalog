namespace :fixdb do
  desc 'run all fixdb tasks'
  task :all => [:collections, :themes, :update_downloads, :create_sitemap, :move_theme_css] do
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
    
    Link.where(category: "Download").each do |link|
      if link.asset.download_urls.where(url: link.url).empty?
        puts "Creating new download URL for #{link.asset.title}: #{link.display_text} - #{link.url}"
        link.asset.download_urls << DownloadUrl.new(name: link.display_text, url: link.url)
        link.save
      end
    end
  end

  desc 'copy all links with download text and add them as download_urls'
  task :download_text => :environment do
    puts "Looking for links set to download to copy..."
    
    Link.where(display_text: "Download").each do |link|
      if link.asset.download_urls.where(url: link.url).empty?
        puts "Creating new download URL for #{link.asset.title}: #{link.display_text} - #{link.url}"
        link.asset.download_urls << DownloadUrl.new(name: link.category, url: link.url)
        link.save
      end
    end
  end

  desc 'create sitemap page if one does not exist in a portal'
  task :create_sitemap => :environment do
    puts "Looking for setups with missing sitemap page..."

    Setup.all.each do |setup|
      next if setup.pages.where(slug: "sitemap").any?
      page = setup.pages.build(slug: "sitemap", main_menu: false, title: "Sitemap", setup_id: setup, description: "This page has been auto-generated.")
      setup.pages << page
    end
  end

  desc 'Move theme css snippet content to theme css field.'
  task :move_theme_css => :environment do
    puts "Looking for empty theme css fields..."

    Setup.all.each do |portal|
      next if portal.theme.css
      if !portal.snippets.where(slug: "theme").first.nil?
        portal.theme.css = portal.snippets.where(slug: "theme").first.content
        portal.theme.save
      end
    end
  end
end