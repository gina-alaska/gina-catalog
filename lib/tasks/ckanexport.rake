require 'json'

namespace :ckanexport do
  desc 'Export data to CKAN'
  task :export, [:portal] => :environment do |_t, args|
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

    export_json = '['
    sep = ''
    portal.entries.each do |entry|
      puts entry.title
      export_json += "#{sep} #{entry.to_json(except: ["id", "uuid", "created_at", "updated_at"])}"
      sep = ","
    end
    export_json += ']'
    open("#{portal_title}-export.json", 'w') do |fileout|
      fileout.write(export_json)
    end
    puts export_json
  end
end
