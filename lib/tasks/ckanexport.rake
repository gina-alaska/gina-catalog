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
    end

    Dir.mkdir('export')
    Dir.mkdir('export/files')

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
      entryHash['slug'] = entry.title.parameterize
      entryHash['start_date'] = entry.start_date
      entryHash['end_date'] = entry.end_date
      entryHash['type'] = entry.entry_type
      entryHash['archived_at'] = entry.archived_at
      entryHash['tags'] = entry.tag_list
      entryHash['data_types'] = entry.data_types
      entryHash['regions'] = entry.regions.pluck(:name)

      # attachments
      attachArray = []
      entry.attachments.each do |attachment|
        attachHash = {}
        attachHash["file_name"] = attachment.file_name
        attachHash["file_size"] = attachment.file_size
        attachHash["category"] = attachment.category
        attachHash["description"] = attachment.description
        attachArray << attachHash

        # save file to export directory
        attdir  = "export/files/#{entry.title.parameterize}"
        if !Dir.exist?(attdir)
          Dir.mkdir("export/files/#{entry.title.parameterize}")
        end

        missing = open("missing_files.report", "w")
        begin
          file = Dragonfly.app.fetch(attachment.file_uid)
          file.to_file("export/files/#{entry.title.parameterize}/#{attachment.file_name}")
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

      # contacts
      priconArray = []
      entry.primary_contacts.each do |contact|
        conHash = {}
        conHash["name"] = contact.name
        conHash["email"] = contact.email
        conHash["phone"] = contact.phone_number
        priconArray << conHash
      end
      entryHash['primary_contacts'] = priconArray

      otherconArray = []
      entry.other_contacts.each do |contact|
        conHash = {}
        conHash["name"] = contact.name
        conHash["email"] = contact.email
        conHash["phone"] = contact.phone_number
        otherconArray << conHash
      end
      entryHash['other_contacts'] = otherconArray

      # ISO-Topics
      isoArray = []
      entry.iso_topics.each do |isotopic|
        next if isotopic.nil?

        isoArray << isotopic.iso_theme_code
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
    system("tar cvf #{portal_title.parameterize}.tar export" )
  end
end

