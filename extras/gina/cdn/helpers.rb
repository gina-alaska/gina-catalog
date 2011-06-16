module GINA
  module CDN
    module Helpers
      def path
        File.join(::GINA::URL, 'libs')
      end

      def include_js_path(name, version=nil)
        lib = ::GINA::CDN::Lib.new(name, version)
        lib.js.collect { |f| File.join(path, f) }
      end

      def include_js(lib, *h)
        javascript_include_tag(include_js_path(lib), *h)
      end

      def include_css_path(name, version=nil)
        lib = ::GINA::CDN::Lib.new(name, version)
        lib.css.collect { |f| File.join(path, f) }
      end

      def include_css(lib, *h)
        stylesheet_link_tag(include_css_path(lib), *h)
      end
    end
  end
end
