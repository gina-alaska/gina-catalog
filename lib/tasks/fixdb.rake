namespace :fixdb do
  desc 'run all fixdb tasks'
  task :all => [:themes, :update_downloads, :create_sitemap, :move_theme_css, :set_default_projection] do
  end
  
  desc 'convert git repos to new upload paths'
  task :convert_repos => :environment do
    Repo.all.each do |repo|
      puts repo.path
      
      begin
        repo.catalog.try(:convert_repo)
        repo.catalog.create_archive_file
      rescue => e
        puts "Error converting repo #{repo.catalog.to_param}: #{e.class}::#{e.message}"
      end
    end
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
      page = setup.pages.build(slug: "sitemap", main_menu: false, title: "Sitemap", setup_id: setup, description: "This page has been auto-generated.", system_page: true)
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

  desc 'Check that all system pages are setup'
  task :set_system_pages => :environment do
    puts "Looking for system pages that are not tagged..."
    system_pages = ["home", "sitemap", "search", "contacts", "404-not-found"]
    system_snippets = ["header", "footer"]

    Page::Content.where(system_page: false, slug: system_pages).update_all(system_page: true)
    Page::Snippet.where(system_page: false, slug: system_snippets).update_all(system_page: true)
  end
  
  desc 'If not set, set the site projection to ESPG:3857.'
  task :set_default_projection => :environment do
    puts "Looking for unset site projections..."

    Setup.where("projection IS NULL OR record_projection IS NULL").each do |portal|
      if portal.projection.nil?
        portal.projection = "EPSG:3857"
      end
      if portal.record_projection.nil?
        portal.record_projection = portal.projection
      end
      portal.save
    end
  end
end