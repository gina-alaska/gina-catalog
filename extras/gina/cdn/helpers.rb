module GINA
  module CDN
    module Helpers
      def path
        File.join(::GINA::URL, 'libs')
      end

      def js_include_path(name, version=nil)
        lib = ::GINA::CDN::Lib.new(name, version)
        lib.js.collect { |f| File.join(path, f) }
      end

      def js_include_tag(lib, *h)
        javascript_include_tag(js_include_path(lib), *h)
      end

      def css_link_path(name, version=nil)
        lib = ::GINA::CDN::Lib.new(name, version)
        lib.css.collect { |f| File.join(path, f) }
      end

      def css_link_tag(lib, *h)
        stylesheet_link_tag(css_link_path(lib), *h)
      end
    end
  end
end
