require 'import'
namespace :admin do
  desc 'Set user to global admin'
  task :set, [:email] => :environment do |_t, args|
    email = args[:email]
    if email.blank?
      puts "Usage: rake \"admin:set[user@email.com]\""
      exit 1
    end

    user = User.where(email: email).first

    if user.nil?
      puts "Could not find user with email: #{email}"
      exit 1
    end

    Portal.all.each do |portal|
      permission = user.permissions.where(portal: portal).first_or_initialize
      permission.roles = { cms_manager: true, data_manager: true, portal_manager: true }
      permission.save
    end

    if user.update_attribute(:global_admin, true)
      puts "Succesfully set #{email} as global admin"
    else
      puts 'There was an error trying to set the user as a global admin'
    end
  end
 
  desc 'Load items (organizations/contact/regions) that do not require a catalog'
  task load: ['load:organizations', 'load:contacts', 'load:regions']

  namespace :load do
    desc 'Load agencies from api'
    task organizations: :environment do
      Import::Organization.fetch
    end

    desc 'Load contacts from api'
    task contacts: :environment do
      Import::Contact.fetch
    end

    desc 'Load regions (geokeywords) from api'
    task regions: :environment do
      Import::Region.fetch
    end

    # Loaded from seeds file
#    desc 'Load data types from api'
#    task data_types: :environment do
#      Import::DataType.fetch
#    end
    
#    desc 'Load ISO topics from api'
#    task iso_topics: :environment do
#      Import::IsoTopic.fetch
#    end

    desc 'Import collections from api (catalog required)'
    task collections: :environment do
      if ENV['catalog'].nil?
        puts 'Please specify the catalog from which collections will be loaded (rake admin:load:collections catalog=catalog.northslope.org)'
        next
      end
      Import::Collection.fetch(ENV['catalog'])
    end

    desc 'Import use agreements from api (catalog required)'
    task use_agreements: :environment do
      if ENV['catalog'].nil?
        puts 'Please specify the catalog from which use agreements will be loaded (rake admin:load:use_agreements catalog=catalog.northslope.org)'
        next
      end
      Import::UseAgreement.fetch(ENV['catalog'])
    end

    desc 'Import entries from api (catalog required)'
    task entries: :environment do
      if ENV['catalog'].nil?
        puts 'Please specify the catalog to load (rake admin:load:entries catalog=catalog.northslope.org)'
        next
      end
      Import::Entry.fetch(ENV['catalog'])
    end
  end
end
