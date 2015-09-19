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
      HTML::Pipeline::MarkdownFilter,
    ], context
  end

  def mustache_context
    attributes
  end

  def render_context(portal)
    context = OpenStruct.new(mustache_context)
    context.portal = portal.mustache_context
    context.snippet = ->(name) { portal.snippets.where(name: name).first.try(:render) }
    context.pages = portal.pages.roots.map(&:mustache_context)
    context.latest_entries = portal.entries.order(updated_at: :desc).limit(5).map(&:mustache_context)

    { mustache: context }
  end
end
