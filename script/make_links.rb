#!/usr/bin/env ruby
require 'fileutils'

source = ARGV.shift
root_path = FileUtils.pwd

raise "Please specify base directory for link from" if source.nil?

dirs = %w{ archives uploads git }

dirs.each do |d|
  from = File.join(source, d)
  to = File.join(root_path, d)
  
  raise "Unable to find #{d} in #{source}" unless File.exists?(from)

  `ln -sf #{from} #{to}`
end


