class RepoFile
  attr_accessor :asset

  def initialize(f, parent = nil)
    @file = f
    @asset = parent
  end

  def path
    File.dirname(@file)
  end

  def path=(p)
    @file = File.join(p, filename)
  end

  def filename
    File.basename(@file)
  end

  def filename=(f)
    @file = File.join(path, File.basename(f))
  end

  def valid?
    File.exists? @file
  end

  def errors
    err = []

    err << 'File does not exist' unless valid?

    err
  end
end