class Video < ActiveRecord::Base
  def fspath
    File.join(Rails.root, 'public', path, filename)
  end
  
  def exists?
    File.exists? File.join(fspath)
  end
end
