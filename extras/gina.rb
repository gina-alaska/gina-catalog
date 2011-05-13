module GINA
  URL='http://glink.gina.alaska.edu/cdn'

  LIBS = {
    :extjs => {
      :versions => {
        :default => '3.3.1',
        :beta => '4.0-beta2'
      },
      :development => {
        :js => ['ext-{version}/adapter/ext/ext-base-debug.js', 'ext-{version}/ext-all-debug.js'],
        :css => ['ext-{version}/resources/css/ext-all.css']
      },
      :production => {
        :js => ['ext-{version}/adapter/ext/ext-base.js', 'ext-{version}/ext-all.js'],
        :css => ['ext-{version}/resources/css/ext-all.css']
      }
    }
  }

  module Helpers
    def load_js(app, *opts)
      base = ['gina/event_manager.js', 'gina/base_controller.js']
      jsfiles = []
      Dir.chdir('public/javascripts') {
        jsfiles << base
        jsfiles << (Dir.glob('gina/*.js') - base)
        jsfiles << Dir.glob('google/*.js') if opts.include? :google
        jsfiles << Dir.glob('openlayers/*.js') if opts.include? :openlayers
        jsfiles << Dir.glob('extjs/*.js')
        jsfiles << "#{app}.js"
        jsfiles << Dir.glob('app/**/*.js')
      }

      javascript_include_tag jsfiles.uniq, :cache => "cached/#{app.to_s}.js"
    end
  end
end

require 'gina/cdn/lib.rb'
require 'gina/cdn/helpers.rb'
