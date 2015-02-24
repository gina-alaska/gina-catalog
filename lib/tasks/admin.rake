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

  task load: ["load:organizations", "load:contacts", "load:entries"]

  namespace :load do
    desc 'Load agencies from api'
    task organizations: :environment do
      Import::Organization.fetch
    end

    desc 'Load contacts from api'
    task contacts: :environment do
      Import::Contact.fetch
    end

    desc 'Import entries from api'
    task entries: :environment do
      if ENV['catalog'].nil?
        puts 'Please specify the catalog to load (rake admin:load:entries catalog=catalog.northslope.org)'
        next
      end
      Import::Entry.fetch(ENV['catalog'])
    end
  end
end
