class ProcessImageTagDrop < Liquid::Drop
  def initialize(image, *opts)
    @image = image
    @opts = opts
  end
  
  def before_method(size)
    @image.thumbnail(size).try(:process, *@opts).try(:url)
  end
end