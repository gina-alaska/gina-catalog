class ProcessImageTagDrop < Liquid::Drop
  def initialize(image, *opts)
    @image = image
    @opts = opts
  end
  
  def before_method(size)
    @image.process(*@opts).png.thumb(size).url
  end
end