namespace :nssi do
  desc 'Convert data records to report records if they have type = report.'
  task :boem, [:portal] => :environment do |_t, args|
    portal_title = args[:portal]
    if portal_title.blank?
      puts "Usage: rake \"nssi:boem[portal title]\""
      exit 1
    end

    portal = Portal.where(title: portal_title).first
    if portal.blank?
      puts "No portal titled \"#{portal_title}\" found!"
      exit 1
    end

    entries = portal.entries.includes(:data_types, :organizations, :entry_organizations).references(:data_types, :organizations, :entry_organizations).where(archived_at: nil).where(data_types: {name: 'Report'}).where(organizations: {acronym: 'BOEM'}).where(entry_organizations: {primary: true})

    entries.each do |entry|
      puts entry.title.to_s
    end
  end
end
