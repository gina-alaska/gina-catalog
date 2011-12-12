class Video < ActiveRecord::Base
  def fullpath
    File.join(path, filename)
  end
  
  def exists?
    File.exists? fullpath
  end
end
