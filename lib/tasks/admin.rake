namespace :admin do
  desc "Set user to global admin"
  task :set, [:email] => :environment do |t, args|
    email = args[:email]
    if email.blank?
      puts "Usage: rake \"admin:set[user@email.com]\""
      exit 1
    end
    
    user = User.where(email: email).first
    if user.nil?
      puts "Could not find user with email: #{email}"
      exit 1
    end
    
    if user.update_attribute(:global_admin, true)
      puts "Succesfully set #{email} as global admin"
    else
      puts "There was an error trying to set the user as a global admin"
    end
  end
end