namespace :db do
  desc "Add database lookups"
  task :lookups => :environment do
    [{
      name: 'Image'
    }, {
      name: 'Database'
    }, {
      name: 'GIS'
    }, {
      name: 'Map'
    }, {
      name: 'Web Service'
    }, {
      name: 'Other'
    }].each { |i| DataType.create(i) }
  end
end