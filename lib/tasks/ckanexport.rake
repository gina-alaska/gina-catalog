require 'json'

namespace :ckanexport do
  desc 'Export portal data to CKAN'
  task :export, [:portal, :archive] => :environment do |_t, args|
    portal_title = args[:portal]
    archive = args[:archive]

    if portal_title.blank?
      puts "Usage: rake \"ckanexport:export[portal title,archive]\""
      exit 1
    end

    portal = Portal.where(title: portal_title).first
    if portal.blank?
      puts "No portal titled \"#{portal_title}\" found!"
      exit 1
    end

    export_json = '['
    sep = ''
    portal.entries.includes(:attachments).each do |entry|
    	if archive and entry.archived?
    		continue
    	end

      puts entry.title

      entryHash = {}

      # entry data
      entryHash['title'] = entry.title
      entryHash['description'] = entry.description
      entryHash['status'] = entry.status
      entryHash['slug'] = entry.slug
      entryHash['start_date'] = entry.start_date
      entryHash['end_date'] = entry.end_date
      entryHash['end_date'] = entry.end_date
      entryHash['end_date'] = entry.end_date

      # attachments
      entry.attachments.each_with_index do |attachment, index|
        entryHash["file_name#{index}"] = attachment.file_name
        entryHash["file_size#{index}"] = attachment.file_size
      end

      export_json += "#{sep} #{entryHash.to_json(except: ["id", "uuid", "created_at", "updated_at"])}"
      sep = ","
    end

    export_json += ']'
    open("#{portal_title}-export.json", 'w') do |fileout|
      fileout.write(export_json)
    end
  end
end
