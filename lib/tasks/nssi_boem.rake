namespace :nssi do
  desc 'Convert data records to report records if they have type = report.'
  task :boem, [:portal] => :environment do |_t, args|
    require 'net/http'

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

    handle = open("nssi_report.txt", "w")
    handle.puts "title, original url, new url, id"

    entries = portal.entries.includes(:data_types, :organizations, :entry_organizations).references(:data_types, :organizations, :entry_organizations).where(archived_at: nil).where(data_types: {name: 'Report'}).where(organizations: {acronym: 'BOEM'}).where(entry_organizations: {primary: true})

    entries.each do |entry|
      handle.write "#{entry.title.to_s},"
      entry.links.each do |link|
        if link.url =~ /pdf$/
          handle.write "#{link.url},"
          link_path = link.url.split("/")
          new_path = "https://espis.boem.gov/final reports/#{link_path[-1]}"
          handle.write "#{new_path},"
        end
      end
      handle.puts entry.id
    end

    handle.close
  end
end
