class ImageTagDrop < Liquid::Drop
  def initialize(image)
    @image = image
  end
  
  def before_method(size)
    @image.file.thumb(size).png.url
  end
end