namespace :import do
  desc 'Import AEA Project info'
  task :aea => :environment do
    
    mapping = {}
    locations = {}
    documents = {}
    
    s = Setup.find(11)
    s.catalogs.destroy_all
    
    projects = JSON.parse(File.read(ENV['PROJECTS']))
    # {"objectid"=>1, "referenceid"=>2265, "locationid"=>2101, "project_name"=>"Kisaralik Hydroelectric Project", "existing"=>0, "statistical_area"=>"SW", "community_served"=>"Bethel", "documentid"=>286, "information_summary"=>"Application for Preliminary Permit from the Federal Energy Regulatory Commission.", "level_of_effort"=>"Permitting", "maps_drawings"=>"yes", "land_use_status"=>"located within proposed Yukon Delta Wildlife Refuge; Kisaralik might be included in \"Wild and Scenic River\" system.", "environmental_concerns"=>"negative impact to anadromous fish and wildlife", "drainage_area_sq_mi"=>"544 sq mi", "active_reservoir_storage_ac_ft"=>"320,750 ac-ft", "flow_cfs"=>"not found", "system_freeze_seasonal_op"=>"not found", "head_ft"=>"not found", "firm_energy_kwh"=>"not found", "system_type"=>"storage", "diversion_structure_dam"=>"308 foot tall concrete faced rockfill dam 1100 feet long", "water_conduits"=>"650 foot long 18 foot wide horseshoe tunnel lined to finished diameter of 16 feet.", "generator"=>"2 vertical Francis turbines and generators rated at 15 MW each", "transmission_line"=>"69 mile long transmission line 138 kV line", "required_infrastructure"=>"dam, spillway, cofferdam, power tunnel, intake, powerhouse, tailrace, 2 mile long access road, ", "installed_capacity_kw"=>"30,000 kW", "plant_factor"=>"not found", "avg_ann_energy_prod_kwh"=>"131,400,000 kWh", "construction_cost"=>"not found", "transmission_cost"=>"not found", "annual_om_cost"=>"not found", "cost_kw"=>"not found", "non_viable"=>"project appears to be feasible as it is currently in permitting phase.", "georeference_comments"=>"", "qc_comments"=>"", "lasteditor"=>"hpalmer", "lastedittime"=>"-1262620536", "originaleditor"=>"hpalmer", "originaledittime"=>"-1262620536"}
    
    projects['features'].each do |f|
      p = f['properties']
      
      d = {
        type: 'Project',
        title: p['project_name'],
        description: p['information_summary'],
        tags: "#{p['existing']>0?'existing':'investigation'},#{p['statistical_area']},#{p['community_served']}"
      }
      
      if mapping[p['objectid']].try(:title) == d[:title]
        puts 'duplicate project?'
        next
      end
      
      mapping[p['objectid']] = s.catalogs.create(d)
      mapping[p['objectid']].owner_setup = s
      mapping[p['objectid']].publish
      
      locations[p['locationid']] ||= []
      locations[p['locationid']] << p['objectid']
      documents[p['documentid']] ||= []
      documents[p['documentid']] << p['objectid']
    end
    
    docs = JSON.parse(File.read(ENV['DOCS']))
    # {"objectid"=>1, "documentid"=>1, "reference_document_title"=>"Small-Scale Hydropower Reconnaissance Study Southwest Alaska", "reference_document_file"=>"SSH-1981-0228", "reference_document_study_area"=>"Southwest", "reference_document_prepared_for"=>"U.S Army Corps of Engineers", "reference_document_prepared_by"=>"R.W. Beck and Associates", "reference_document_date"=>"April 1981", "report_type"=>"SSH", "link_to_report"=>"http://akenergyinventory.org/hyd/SSH-1981-0228.pdf"}
    docs['features'].each do |f|
      p = f['properties']
      next if documents[p['documentid']].nil? 
      documents[p['documentid']].each do |cid|
        c = mapping[cid]
        if c.nil?
          puts "Unable to find a catalog record for document #{p['documentid']}"
          next
        end
        c.links.create({ display_text: p['reference_document_title'], category: 'Report', url: p['link_to_report'] })
      end
    end
    
    locs = JSON.parse(File.read(ENV['LOCATIONS']))
    # {"objectid"=>1, "status"=>"Investigation Sites", "locationid"=>1, "lon"=>-165.780192, "lat"=>54.136676}
    
    locs['features'].each do |f|
      p = f['properties']
      # puts p.inspect
      next if locations[p['locationid']].nil?
      
      locations[p['locationid']].each do |cid|
        c = mapping[cid]
        if c.nil?
          puts "Unable to find a catalog record for location #{p['locationid']}"
          next
        end
        c.locations.create({ name: p['status'], geom: "POINT(#{p['lon']} #{p['lat']})" })
      end
    end
  end
  
  
  desc 'Import agencies from FILE=[file]'
  task :agencies => :environment do
    unless ENV['FILE']
      puts "No file specified"
      exit
    end
    
    require 'csv'
    agencies = CSV.new(File.open(ENV['FILE'], 'r'), headers: :first_row)
    
    notfound = 0
    created = 0
    failed = 0
    agencies.each do |a|
      agency = Agency.where('acronym ilike ?', a['acronym']).first
      if agency.nil?
        notfound += 1 
        
        agency = Agency.new(name: a['name'], acronym: a['acronym'], category: 'Unknown')
        if agency.save
          created += 1 
        else
          puts a['name']
          puts agency.errors.full_messages
          failed += 1
        end
      end
      
    end
    
    puts "Couldn't find #{notfound} agencies"
    puts "Created #{created} agencies"
    puts "Failed to create #{failed} agencies"
  end
  
  desc 'Clear boem records'
  task :clear_boem => :environment do
    ds = DataSource.where(name: 'BOEM').first
    puts "Deleting..."
    Asset.destroy_all(data_source_id: ds)
    
  end
  
  desc 'Import boem records from FILE=[file]'
  task :boem => :environment do
    unless ENV['FILE']
      puts "No file specified"
      exit
    end
    
    ds = DataSource.where(name: 'BOEM').first
    if ds.nil?
      ds = DataSource.create(name: 'BOEM')
    end
    
    #Link-BOEM Alaska Environmental Studies Program
    #Link_BOEM ESPIS System
    
    require 'csv'
    records = CSV.new(File.open(ENV['FILE'], 'r'), headers: :first_row)
    
    primary = Agency.where('acronym ilike ?', 'BOEM').first
    
    
    records.each do |r|
      data = Asset.new(
        title: r['title'].chomp,
        description: r['description'].chomp + 'kb',
        data_source: ds,
        source_agency: primary,
        funding_agency: primary,
        status: r['status'],
        published_at: Time.now
      )
      
      data.end_date = DateTime.new(r['end_date'].to_i, 1, 1, 0, 0, 0, 'AKDT') if r['end_date'].present?
      
      %w{ other_agency_1 other_agency_2 other_agency_3 other_agency_4 other_agency_5 }.each do |field|
        a =  Agency.where('name ilike ?', r[field]).first
        data.agencies << a unless a.nil?
      end
  
      geolocation = Geokeyword.where(name: r['geotag'])
      data.geokeywords << geolocation
      
      tags = r['tags'].split(',')
      data.tags = tags
      
      link = Link.new(category: 'Report', display_text: 'Download', url: r['link_download'])
      data.links << link
      link = Link.new(category: 'Website', display_text: 'BOEM Alaska Environmental Studies Program', url: r['link_aesp'])
      data.links << link
      link = Link.new(category: 'Website', display_text: 'BOEM ESPIS System', url: r['link_espis'])
      data.links << link
      
      data.save!
      print '.'
      #puts data.title
    end
  end
end