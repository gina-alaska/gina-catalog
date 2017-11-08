namespace :trim do
  desc 'read all entries and remove whitespace from the titles.'
  task :whitespace => :environment do

    PublicActivity.enabled = false
    count = 0
    Entry.find_each do |entry|
      entry.update_attribute(:title, entry.title.strip)
      count += 1 if entry.previous_changes['title']
    end
    puts "Fixed #{count} entry titles."
    PublicActivity.enabled = true
  end
end
