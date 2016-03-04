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
    context = as_context
    context[mustache_route] = context.dup

    context
  end

  def as_context
    attrs = mustache_sanitize(attributes)
    attrs['gid'] = self.to_global_id unless self.new_record?
    attrs['url'] = mustache_url unless self.new_record?

    attrs
  end

  def mustache_sanitize(items)
    items.each_with_object({}) do |item,hash|
      hash[item.first] = item.last.to_s
    end
  end

  def mustache_route
    self.class.name.parameterize
  end

  def mustache_url
    h.send(:"#{mustache_route}_path", mustache_url_params) if h.respond_to?(:"#{self.mustache_route}_path")
  end

  def mustache_url_params
    to_param
  end

  def map_mustache_safe(collection, page)
    collection.each_with_object([]) { |i,a| a << i.mustache_context(page) }
  end

  def render_context(portal, page = nil)
    data = OpenStruct.new()
    unless portal.nil?
      data.portal = portal
    end

    if !page.nil?
      data.page = page
    end

    { data: data }
  end

  def check_handlebarjs_syntax
    return if content.blank?

    begin
      render
    rescue HTML::Pipeline::Filter::InvalidDocumentException => e
      Rails.logger.error e.backtrace
      errors.add(:content, "contains invalid content { #{e.message.split(':').first} }!")
    rescue V8::Error => e
      Rails.logger.error e.backtrace
      errors.add(:content, "contains invalid content { #{e.message.split(':').first} }!")
    end
  end
end
