require 'dragonfly'
require 'pdf_processor'

app = Dragonfly[:media]
app.configure_with(:imagemagick)
app.configure_with(:rails)
app.processor.register(PdfProcessor)

app.define_macro(ActiveRecord::Base, :image_accessor)
app.define_macro(ActiveRecord::Base, :file_accessor)

app.datastore.configure do |d|
  d.root_path = Rails.root.join('uploads').to_s
end
