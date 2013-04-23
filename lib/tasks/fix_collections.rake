namespace :fix do
  desc 'migrate collections to the new setup'
  task :collections => :environment do
    CatalogCollection.all.each do |cc|
      c = Collection.new({ name: cc.name, description: cc.description, setup_id: cc.setup_id })
      c.catalogs = cc.catalogs
      c.save!
    end
  end
  
  task :reset => :environment do
  end
end