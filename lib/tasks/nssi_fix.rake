namespace :fixnssi do
  desc 'Convert data records to report records if they have type = report.'
  task :convert, [:portal] => :environment do |_t, args|
    portal_title = args[:portal]
    if portal_title.blank?
      puts "Usage: rake \"fixnssi:convert[portal title]\""
      exit 1
    end

    portal = Portal.where(title: portal_title).first
    if portal.blank?
      puts "No portal titled \"#{portal_title}\" found!"
      exit 1
    end

    entry_type = EntryType.where(name: 'Report').first
    if entry_type.blank?
      puts 'No entry type "Report", please create a report entry type and re-run task!'
      exit 1
    end

    entries = portal.entries.joins(:data_types).where(data_types: { name: 'Report' })
    entries.find_each { |e| e.update_attributes( entry_type_id: entry_type.id ) }
  end
end
