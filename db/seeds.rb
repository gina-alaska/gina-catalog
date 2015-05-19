# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Rails.env.development?
  p = Portal.where(
    title: 'Catalog Development Portal',
    acronym: 'gLynx Portal',
    contact_email: 'support@gina.alaska.edu'
  ).first_or_initialize
  p.urls.build(url: 'catalog.192.168.222.225.xip.io', default: true) if p.new_record?
  p.urls.build(url: 'catalog.127.0.0.1.xip.io', default: false) if p.new_record?
  p.save

  Contact.where(name: 'Will Fisher', email: 'will@alaska.edu').first_or_create

  Organization.where(name: 'Geographic Information Network of Alaska', acronym: 'GINA').first_or_create

  Entry.reindex
  Organization.reindex
end

EntryType.where(name: 'Project', description: 'catalog record for projects with no associated data/observation files', color: '#c09853').first_or_create
EntryType.where(name: 'Data', description: 'catalog record for projects with associated data/observation files', color: '#3a87ad').first_or_create

data_types = ['Image','Database', 'GIS', 'Map', 'Web Service', 'Other', 'Report']
data_types.each do |data_type|
  DataType.where(name: data_type).first_or_create
end

networks = [['Facebook', 'fa-facebook'], ['GitHub', 'fa-github'], ['Google+', 'fa-google-plus'],
            ['Instagram', 'fa-instagram'], ['Linkedin', 'fa-linkedin'], ['Tumblr', 'fa-tumblr'],
            ['Twitter', 'fa-twitter'], ['YouTube', 'fa-youtube']]
networks.each do |network|
  SocialNetworkConfig.where(name: network[0], icon: network[1]).first_or_create
end

iso_topics = [
  [ "001", "farming", "rearing of animals and/or cultivation of plants"],
  [ "002", "biota", "flora and/or fauna in natural environment"],
  [ "003", "boundaries", "legal land descriptions"],
  [ "004", "climatologyMeteorologyAtmosphere", "processes and phenomena of the atmosphere"],
  [ "005", "economy", "economic activities, conditions and employment"],
  [ "006", "elevation", "height above or below sea level"],
  [ "007", "environment", "environmental resources, protection and conservation"],
  [ "008", "geoscientificInformation", "information pertaining to earth sciences"],          
  [ "009", "health", "health, health services, human ecology, and safety"],
  [ "010", "imageryBaseMapsEarthCover", "base maps"],
  [ "011", "intelligenceMilitary", "military bases, structures, activities"],
  [ "012", "inlandWaters", "inland water features, drainage systems and their characteristics"],
  [ "013", "location", "positional information and services"],
  [ "014", "oceans", "features and characteristics of salt water bodies (excluding inland waters)"],
  [ "015", "planningCadastre", "information used for appropriate actions for future use of the land"],
  [ "016", "society", "characteristics of society and cultures"],                
  [ "017", "structure", "man-made construction"],                
  [ "018", "transportation", "means and aids for conveying persons and/or goods"],                
  [ "019", "utilitiesCommunication", "energy, water and waste systems and communications infrastructure and services"]
]
iso_topics.each do |iso_topic|
  IsoTopic.where( iso_theme_code: iso_topic[0], name: iso_topic[1], long_name: iso_topic[2] ).first_or_create
end