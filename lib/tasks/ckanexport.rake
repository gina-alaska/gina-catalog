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

    if Dir.exist?('export')
      system('rm -r export')
    else
      Dir.mkdir('export')
      Dir.mkdir('export/files')
    end

    export_json = '['
    sep = ''
    portal.entries.includes(:attachments).each do |entry|
    	if !archive and entry.archived?
    		next
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
      attachArray = []
      entry.attachments.each do |attachment|
        next if attachment.file_name == "imported_locations"

        attachHash = {}
        attachHash["file_name"] = attachment.file_name
        attachHash["file_size"] = attachment.file_size
        attachHash["category"] = attachment.category
        attachHash["description"] = attachment.description
        attachArray << attachHash

        # save file to export directory
        missing = open("missing_files.report", "w")
        begin
          file = Dragonfly.app.fetch(attachment.file_uid)
          file.to_file("export/files/#{attachment.file_name}")
        rescue
          missing.write "No file #{attachment.file_name} for record #{entry.title}"
        end
        missing.close
      end
      entryHash['attachments'] = attachArray

      # bounds
      bboxArray = []
      entry.bboxes.each do |bound|
        bboxHash = {}
        bboxHash["type"] = bound.boundable_type
        bboxHash["geom"] = RGeo::GeoJSON.encode(bound.geom).to_json
        bboxArray << bboxHash
      end
      entryHash['bounds'] = bboxArray

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
      orgArray = []
      entry.organizations.each do |org|
        orgHash = {}
        orgHash["name"] = org.name
        orgHash["category"] = org.category
        orgHash["description"] = org.description
        orgHash["logo_name"] = org.logo_name
        orgArray << orgHash
      end
      entryHash['organizations'] = orgArray

      # collections
      collArray = []
      entry.collections.each do |collection|
        collHash = {}
        collHash["name"] = collection.name
        collHash["description"] = collection.description
        collHash["hidden"] = collection.hidden
        collArray << collHash
      end
      entryHash['collections'] = collArray

      # ISO-Topics
      isoArray = []
      entry.iso_topics.each do |isotopic|
        isoHash = []
        isoHash["code"] = isotopic.iso_theme_code
        isoHash["name"] = isotopic.name
        isoHash["long_name"] = isotopic.long_name
        isoArray << isoHash
      end
      entryHash['iso_topics'] = isoArray

      export_json += "#{sep} #{entryHash.to_json(except: ["id", "uuid", "created_at", "updated_at"])}"
      sep = ","
    end

    export_json += ']'
    open("export/#{portal_title}-export.json", 'w') do |fileout|
      fileout.write(export_json)
    end

    # tar export directory
    system("tar cvf #{portal_title}.tar export" )
  end
end
