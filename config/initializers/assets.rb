# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components', 'font-awesome')

Rails.application.config.assets.precompile += %w(
  bootstrap/dist/fonts/glyphicons-halflings-regular.eot
  bootstrap/dist/fonts/glyphicons-halflings-regular.woff
  bootstrap/dist/fonts/glyphicons-halflings-regular.ttf
  select2/select2.png
  select2/select2-spinner.gif
  select2/select2x2.png
)
