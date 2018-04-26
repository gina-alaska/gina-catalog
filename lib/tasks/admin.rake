require 'import'
namespace :admin do
  PublicActivity.enabled = false
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

  task fix_entry_owners: :environment do
    Entry.find_each(&:set_owner_portal)
  end

  desc 'Build a uuid for each entry'
  task fix_uuid: :environment do
    Entry.find_each do |entry|
      entry.create_uuid
      entry.save
    end
  end

  desc 'Load all items'
  task load: ['load:regions', 'load:collections', 'load:use_agreements', 'load:organizations', 'load:contacts', 'load:entries']

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

    desc 'Import collections from api (catalog required)'
    task collections: :environment do
      if ENV['catalog'].nil?
        puts 'Please specify the catalog from which collections will be loaded (rake admin:load:collections catalog=catalog.northslope.org)'
        next
      end
      if ENV['portal'].nil?
        puts 'Please specify the portal to load (rake admin:load:collections catalog=catalog.northslope.org portal=1234)'
        next
      end
      Import::Collection.fetch(ENV['catalog'], ENV['portal'])
    end

    desc 'Import use agreements from api (catalog required)'
    task use_agreements: :environment do
      if ENV['catalog'].nil?
        puts 'Please specify the catalog from which use agreements will be loaded (rake admin:load:use_agreements catalog=catalog.northslope.org)'
        next
      end
      if ENV['portal'].nil?
        puts 'Please specify the portal to load (rake admin:load:use_agreements catalog=catalog.northslope.org portal=1234)'
        next
      end
      Import::UseAgreement.fetch(ENV['catalog'], ENV['portal'])
    end

    desc 'Import entries from api (catalog required)'
    task entries: :environment do
      if ENV['catalog'].nil?
        puts 'Please specify the catalog to load (rake admin:load:entries catalog=catalog.northslope.org)'
        next
      end
      if ENV['portal'].nil?
        puts 'Please specify the portal to load (rake admin:load:entries catalog=catalog.northslope.org portal=1234)'
        next
      end
      Import::Entry.fetch(ENV['catalog'], ENV['portal'])
    end

    desc 'Import cms from api (catalog required)'
    task cms: :environment do
      if ENV['catalog'].nil?
        puts 'Please specify the catalog to load (rake admin:load:cms catalog=catalog.northslope.org)'
        next
      end
      if ENV['portal'].nil?
        puts 'Please specify the portal to load (rake admin:load:cms catalog=catalog.northslope.org portal=1234)'
        next
      end

      Import::Layout.fetch(ENV['catalog'], ENV['portal'])
      Import::Snippet.fetch(ENV['catalog'], ENV['portal'])
      Import::Theme.fetch(ENV['catalog'], ENV['portal'])
      Import::Page.fetch(ENV['catalog'], ENV['portal'])
    end

    task attachments: :environment do
      if ENV['catalog'].nil?
        puts 'Please specify the catalog to load (rake admin:load:cms catalog=catalog.northslope.org)'
        next
      end
      if ENV['portal'].nil?
        puts 'Please specify the portal to load (rake admin:load:cms catalog=catalog.northslope.org portal=1234)'
        next
      end

      Import::Attachment.fetch(ENV['catalog'], ENV['portal'])
    end
  end
end
