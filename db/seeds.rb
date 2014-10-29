# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Rails.env.development? or Rails.env.test?
  s = Site.create({ 
    title: "Catalog Development", 
    acronym: 'gLynx', 
    contact_email: 'support@gina.alaska.edu' 
  })
  s.urls.create({ url: 'catalog.192.168.222.225.xip.io', default: true }) unless s.new_record?

  Contact.where(name: 'Will Fisher', email: 'will@alaska.edu').first_or_create
end
