module Glynx
  class MustacheFilter < HTML::Pipeline::Filter
    def call
      ::Mustache.render(html, context[:mustache])
    end
  end
end
