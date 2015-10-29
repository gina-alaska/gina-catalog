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
    context = OpenStruct.new(page.try(:mustache_context) || mustache_context)
    context.public = !page.try(:draft)

    context.page = page

    context.parent_page = page.try(:parent).try(:mustache_context)

    context.portal = portal.mustache_context(page)
    context.snippet = ->(name) { portal.snippets.where(name: name).first.try(:render, page) }
    context.pages = map_mustache_safe(portal.pages.roots.visible, page)

    unless page.nil?
      context.image_attachments = map_mustache_safe(page.cms_page_attachments.map(&:attachment), page)
    end
    context.latest_entries = map_mustache_safe(portal.entries.order(updated_at: :desc).limit(5), page)

    { mustache: context }
  end
end
