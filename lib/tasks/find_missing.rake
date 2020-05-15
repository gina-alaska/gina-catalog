namespace :find_missing do
  desc 'find missing attachments'
  task :find_missing, [:portal] => :environment do |_t, args|
    portal_title = args[:portal]

    if portal_title.blank?
      puts "Usage: rake \"ckanexport:export[portal title]\""
      exit 1
    end

    portal = Portal.where(title: portal_title).first
    if portal.blank?
      puts "No portal titled \"#{portal_title}\" found!"
      exit 1
    end

    EntryPortal.where(portal_id: portal.id).pluck(entry_id).each do |entry_id|
      Entry.where(id: entry_id).attachments.each do |attachment|
        puts attachment.file_name
      end
    end
  end
end
