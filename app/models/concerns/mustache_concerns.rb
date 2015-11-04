module MustacheConcerns
  extend ActiveSupport::Concern

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
    attributes
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
