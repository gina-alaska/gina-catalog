class ImageTagDrop < Liquid::Drop
  def initialize(image)
    @image = image
  end
  
  def before_method(size)
    @image.file.png.thumb(size).url
  end
end