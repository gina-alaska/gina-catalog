module GINA
  URL='http://glink.gina.alaska.edu/cdn'

  LIBS = {
    :extjs => {
      :versions => {
        :default => '4.0.2a',
        :beta => '4.0.2a'
      },
      :development => {
        :js => ['ext-{version}/ext-all-debug.js'],
        :css => ['ext-{version}/resources/css/ext-all.css']
      },
      :production => {
        :js => ['ext-{version}/ext-all.js'],
        :css => ['ext-{version}/resources/css/ext-all.css']
      }
    }
  }

  module Helpers
    def include_app_js(app, *opts)
      jsfiles = []
      Dir.chdir('public/javascripts') {
        jsfiles << Dir.glob('gina/*.js')
        jsfiles << Dir.glob('google/*.js') if opts.include? :google
        jsfiles << Dir.glob('openlayers/*.js') if opts.include? :openlayers
        jsfiles << Dir.glob('extjs/*.js')
        jsfiles << "#{app}.js"
        jsfiles << Dir.glob('app/**/*.js')
      }

      javascript_include_tag jsfiles.uniq, :cache => (Rails.env == 'production' ? 'cached/application' : false)
    end
  end
end

require 'gina/cdn/lib.rb'
require 'gina/cdn/helpers.rb'
