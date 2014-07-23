class ProcessImageTagDrop < Liquid::Drop
  def initialize(image, *opts)
    @image = image
    @opts = opts
  end
  
  def before_method(size)
    helpers.cms_media_path @image.file_uid, size: size
  end
  
  def helpers
    Rails.application.routes.url_helpers
  end
end