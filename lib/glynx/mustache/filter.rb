module Glynx
  module Mustache
    class Filter < HTML::Pipeline::Filter
      def initialize(*args)
        super(*args)
        @handlebars = Handlebars::Context.new
        @helpers = Glynx::Mustache::Helpers.new(current_page, current_portal, @handlebars)
        register_helpers
      end

      def register_helpers
        @helpers.methods.each do |method|
          next unless method.match?(/_helper$/)
          helper_name = method.to_s.gsub(/_helper$/, '')
          @handlebars.register_helper(helper_name, &@helpers.method(method))
        end

        @handlebars.partial_missing do |name|
          lambda do |this, context, block|
            page, _block = @helpers.from_context(this, context, block, current_page)
            snippet = current_portal.snippets.friendly.find(name)
            ctx = page.render_context(current_portal, page)

            snippet.render(ctx)
          end
        end
      end

      def data
        context[:data]
      end

      def current_portal
        data.portal
      end

      def current_page
        data.page
      end

      def clean_context
        data.marshal_dump.each_with_object({}) do |k, c|
          c[k.first] = if k.last.respond_to? :mustache_context
                         k.last.mustache_context(data.page)
                       elsif k.last.respond_to? :attributes
                         k.last.attributes
                       else
                         k.last
                       end
        end
      end

      def call
        # ::Mustache.render(html, context[:mustache])
        template = @handlebars.compile(html)

        template.call(clean_context)
      end
    end
  end
end
