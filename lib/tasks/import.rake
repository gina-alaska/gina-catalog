namespace :import do
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