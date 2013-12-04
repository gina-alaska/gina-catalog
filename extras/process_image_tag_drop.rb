class ProcessImageTagDrop < Liquid::Drop
  def initialize(image, *opts)
    @image = image
    @opts = opts
  end
  
  def before_method(size)
    @image.process(*@opts).process(:page, 0).png.thumb(size).url
  end
end