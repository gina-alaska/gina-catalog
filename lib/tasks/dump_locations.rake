namespace :dump do
  desc "dump locations"
  task :locations => :environment do
    ds = DataSource.where(name: 'NSSI')
    projects = Project.where(data_source_id: ds)
    # locations = []
    # output = {
    #   :metadata => {
    #     :idinfo => []
    #   }
    # }
    
    require 'builder'
    output = ''
    xml = Builder::XmlMarkup.new(:target => output)
    xml.instruct!
    xml.metadata do
      projects.each do |p| 
        locations = p.locations.where('geom is not null')
        next if locations.empty? and p.geokeywords.empty?
        
        xml.idinfo do
          xml.title p.title
          xml.link "http://catalog.northslope.org/catalog/#{p.id}"
          xml.short p.description[0..200].gsub("\n",'')
          xml.primorgcode p.source_agency.try(:acronym)
          xml.primorgpath ''
          xml.primorgproj p.id
          p.geokeywords.each do |keyword|
            xml.placekey keyword.name
          end
          locations.each do |l|
            xml.placekey (l.region.nil? or l.region.empty?) ? 'unknown' : l.region
          end
          xml.cntper p.primary_contact.try(:full_name)
          xml.begdate p.start_date.try(:year)
          xml.enddate p.end_date.try(:year)
          
          xml.spdom do
            p.geokeywords.each do |keyword|
              xml.Point do
                geom = keyword.geom.respond_to?(:centroid) ? keyword.geom.centroid : keyword.geom
                xml.coordinates(crs: 'epsg4326') { xml.text! "#{geom.x},#{geom.y}" }
              end
            end            
            locations.each do |l|
              xml.Point do
                geom = l.geom.respond_to?(:centroid) ? l.geom.centroid : l.geom
                xml.coordinates(crs: 'epsg4326') { xml.text! "#{geom.x},#{geom.y}" }
              end
            end
          end
          xml.logisticsupport do
            xml.cntorg
          end
        end
      end
    end
    puts output
  end
end
