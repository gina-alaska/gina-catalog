namespace :font_awesome do
  desc 'Convert the font awesome _icons.scss file to YAML. FILE=[file]'
  task :convert => :environment do
    unless ENV['FILE']
      puts "No input file specified"
      exit
    end
    puts "Converting #{ENV['FILE']} to YAML..."

    icons = Array.new
    File.open(ENV['FILE']).each do |line|
      next unless line =~ /^.icon*/
      icon = line.split(":")[0]
      icons.push("\"#{icon}\"")
    end
    icons.sort!

    file = File.new("#{Rails.root}/config/font_awesome.yml", "w")
    icons.each do |icon|
      file.write("- #{icon}\n")
    end
    file.close

    puts "done."
  end
end
