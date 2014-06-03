class ImageTagDrop < Liquid::Drop
  def initialize(image)
    @image = image
  end
  
  def before_method(size)
    helpers.cms_media_path @image.file_uid, size: size
  end
  
  def helpers
    Rails.application.routes.url_helpers
  end
end