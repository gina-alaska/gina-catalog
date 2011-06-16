class AssetFile < ActiveRecord::Base
  belongs_to :asset
  belongs_to :mime_type

  before_create :detect_mime_type
  after_save :update_asset
  before_destroy :delete_file

  delegate :path, :to => :asset

  def file=(fp)
    self.filename = fp.original_filename
    self.add_file_to_svn(fp)
    self.size = fp.size
  end

  def add_file_to_svn(fp)
    repo = Svn.new($svn_root_dir)
    repo.update

    fullpathname = File.join($svn_root_dir, self.full_filename)
    fullpath = File.dirname(fullpathname)

    if !File.exists?(fullpath)
      FileUtils.mkdir_p(fullpath)
    elsif File.exists?(fullpathname)
      raise Exception, "File already exists, please create a new asset to upload to upload this file"
    end

    File.open(fullpathname, "w") do |f|
      f.write(fp.read)
    end
    
    repo.stepped_add(self.path)
    repo.add(self.full_filename)
    repo.commit("Adding asset file: #{self.filename}, asset.id=#{self.asset.try(:id)}")
  end

  def extension
    self.filename.match(/\.(\w+)$/)[1]
  end

  def update_asset
    self.asset.touch
    self.asset.save
  end

  def detect_mime_type
    ext = MimeTypeExtension.find_by_extension(".#{self.extension}")
    self.mime_type = ext.mime_type if ext
  end

  def delete_file
    repo = Svn.new($svn_root_dir)

    return true unless File.exists? self.full_filename
    FileUtils.rm(self.full_filename)

    repo.remove(self.full_filename)
    repo.commit("Deleting asset file, asset.id=#{self.asset.try(:id)} - {#{self.filename}}")
  end

  def full_filename
    File.join(self.path, self.filename)
  end
end
