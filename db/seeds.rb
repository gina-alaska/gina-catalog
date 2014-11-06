# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if Rails.env.development?
  p = Portal.create({ 
    title: "Catalog Development Portal", 
    acronym: 'gLynx Portal', 
    contact_email: 'support@gina.alaska.edu' 
  })
  p.urls.create({ url: 'catalog.192.168.222.225.xip.io', default: true }) unless p.new_record?

  Contact.where(name: 'Will Fisher', email: 'will@alaska.edu').first_or_create
end

EntryType.where(name: 'Project', description: 'catalog record for projects with no associated data/observation files', color: '#c09853').first_or_create
EntryType.where(name: 'Data', description: 'catalog record for projects with associated data/observation files', color: '#3a87ad').first_or_create


