namespace :trim do
  desc 'read all entries and remove whitespace from the titles.'
  task :whitespace => :environment do

    PublicActivity.enabled = false
    count = 0
    Entry.find_each do |entry|
      if !entry.title.strip!.nil?
        entry.save
        count += 1
      end
    end
    puts "Fixed #{count} entry titles."
    PublicActivity.enabled = true
  end
end
