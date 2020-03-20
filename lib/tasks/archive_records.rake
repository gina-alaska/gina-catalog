namespace :archive_entries do
  desc 'Archive specified entries'
  task :archive, [:portal, :org, :type] => :environment do |_t, args|
    portal_title = args[:portal]
    organization = args[:org]
    entry_type = args[:type]

    if portal_title.blank?
      puts "Usage: rake \"ckanexport:export[portal title,archive]\""
      exit 1
    end

    portal = Portal.where(title: portal_title).first
    if portal.blank?
      puts "No portal titled \"#{portal_title}\" found!"
      exit 1
    end

    portal.entries.where(primary_org: organization, entry_type: entry_type).each do |entry|
      puts entry.title
    end
  end
end
