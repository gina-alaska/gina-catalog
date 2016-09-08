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

    portal.entries.find_each do |entry|
      if entry.data_types.pluck(:name).include?('Report')
        entry.entry_type = entry_type
        entry.save
      end
    end
  end
end
