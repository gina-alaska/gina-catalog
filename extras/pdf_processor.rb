class PdfProcessor
  include Dragonfly::Configurable
  include Dragonfly::ImageMagick::Utils
  
  def page(temp_object, page=0, format=nil, args='')
    tempfile = new_tempfile(format)
    run convert_command, %(#{quote(temp_object.path+"[#{page}]") if temp_object} #{args} #{quote(tempfile.path)})
    tempfile
  end
end