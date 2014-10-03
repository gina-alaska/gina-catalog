namespace :fixdb do
  desc 'run all fixdb tasks'
  task :all => [:set_system_pages] do
  end

  desc 'convert download counts'
  task :convert_download_counts => [:environment] do
    ActivityLog.where(loggable_type: 'ContactInfo').each do |al|
      catalog = al.loggable.catalog
      file = File.basename(al.log[:url])
      download = al.loggable.catalog.uploads.where('file_uid like ?', "%#{file}").first
      if download.nil?
        download = al.loggable.catalog.download_urls.where(url: al.log[:url]).first
      end
      
      new_al = catalog.activity_logs.downloads.create({
        user: al.user, contact_info: al.loggable, catalog: catalog, loggable: download, 
        setup_id: al.log[:setup_id], log: { name: download.try(:to_s) },
      })
      new_al.update_attribute(:created_at, al.created_at)
      # al.destroy
    end
  end
  
  desc 'fix up activity logs'
  task :fix_activity_logs => [:environment] do
    ActivityLog.where(catalog_id: nil).each do |al|
      if al.loggable.respond_to?(:catalog)
        al.update_attribute(:catalog, al.loggable.catalog)
      end
    end
    ActivityLog.where(setup_id: nil).each do |al|
      if al.log.try(:[], :setup_id)
        al.update_attribute(:setup_id, al.log[:setup_id])
      elsif !al.catalog.nil?
        al.update_attribute(:setup, al.catalog.try(:owner_setup))
      elsif al.loggable.respond_to?(:catalog)
        al.update_attribute(:setup, al.loggable.catalog.try(:owner_setup))
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