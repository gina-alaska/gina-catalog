class ImageTagDrop < Liquid::Drop
  def initialize(image)
    @image = image
  end
  
  def before_method(size)
    @image.thumbnail(size).try(:url)
  end
end