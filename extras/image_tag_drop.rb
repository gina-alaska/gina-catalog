class ImageTagDrop < Liquid::Drop
  def initialize(image)
    @image = image
  end
  
  def before_method(size)
    @image.process(:page, 0).png.thumb(size).url
  end
end