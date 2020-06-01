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

    entries = portal.entries.includes(:data_types, :organizations, :entry_organizations).references(:data_types, :organizations, :entry_organizations).where(archived_at: nil).where(data_types: {name: 'Report'}).where(organizations: {acronym: 'BOEM'}).where(entry_organizations: {primary: true})

    entries.each do |entry|
      handle.puts "------------------------"
      handle.puts entry.title.to_s
      entry.links.each do |link|
        if link.url =~ /pdf$/
          handle.puts link.display_text
          handle.puts link.url
          valid_link = ""

          begin
            uri = URI(link.url)
            response = Net::HTTP.get_response(uri)

            valid_link = response.code.to_i < 400
          rescue
            valid_link = false
          end
          handle.puts valid_link
        end
      end
    end

    handle.close
  end
end
