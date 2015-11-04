module MustacheConcerns
  extend ActiveSupport::Concern

  included do
    delegate :url_helpers, to: "Rails.application.routes"
    alias :h :url_helpers
  end

  def basic_pipeline(context)
    HTML::Pipeline.new [
      Glynx::MustacheFilter
    ], context
  end

  def markdown_pipeline(context)
    HTML::Pipeline.new [
      Glynx::MustacheFilter,
      HTML::Pipeline::MarkdownFilter
    ], context
  end

  def mustache_context(page = nil)
    attrs = attributes.dup

    attrs['item'] = self.to_global_id
    attrs['url'] = h.send :"#{self.mustache_route}_path", id if h.respond_to?(:"#{self.mustache_route}_path")

    attrs
  end

  def mustache_route
    self.class.name.parameterize
  end

  def map_mustache_safe(collection, page)
    collection.each_with_object([]) { |i,a| a << i.mustache_context(page) }
  end

  def render_context(portal, page = nil)
    portal.readonly!
    data = OpenStruct.new({ portal: portal })

    unless page.nil?
      page.readonly!
      data.page = page
    end

    { data: data }
  end
end
