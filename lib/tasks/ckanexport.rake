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
    	if !archive and entry.archived?
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
      entryHash['attachments'] = {}
      entry.attachments.each do |attachment|
        entryHash['attachments']["file_name"] = attachment.file_name
        entryHash['attachments']["file_size"] = attachment.file_size
        entryHash['attachments']["category"] = attachment.category
        entryHash['attachments']["description"] = attachment.description
      end

      # bounds
      entryHash['bounds'] = {}
      entry.bboxes.each do |bound|
        entryHash['bound']["type"] = bound.boundable_type
        entryHash['bound']["geom"] = bound.geom
      end

      # links
      linkArray = []
      entry.links.each do |link|
        linkHash = {}
        linkHash["url"] = link.url
        linkHash["category"] = link.category
        linkHash["display_text"] = link.display_text
        linkArray << linkHash
      end
      entryHash['links'] = linkArray

      # organizations
      entryHash['organizations'] = {}
      entry.organizations.each do |org|
        entryHash['organizations']["name"] = org.name
        entryHash['organizations']["category"] = org.category
        entryHash['organizations']["description"] = org.description
        entryHash['organizations']["logo_name"] = org.logo_name
      end

      # collections
      entryHash['collections'] = {}
      entry.collections.each do |collection|
        entryHash['collections']["name"] = collection.name
        entryHash['collections']["description"] = collection.description
        entryHash['collections']["logo_name"] = collection.logo_name
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
