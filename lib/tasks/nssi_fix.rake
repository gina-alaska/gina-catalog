namespace :fixnssi do
  desc 'Convert data records to report records if they have type = report.'
  task convert: :environment do
    entry_type = EntryType.where(name: 'Report').first
    if entry_type.blank?
      puts 'No entry type "Report", please create a report entry type and re-run task!'
      exit()
    end

    Entry.find_each do |entry|
      if entry.data_types.pluck(:name).include?('Report')
        entry.entry_type = entry_type
        entry.save
      end
    end
  end
end
