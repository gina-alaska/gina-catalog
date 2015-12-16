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
    attrs['url'] = mustache_url

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
    ro_portal = Portal.find(portal.id)
    ro_portal.readonly!
    data = OpenStruct.new({ portal: ro_portal })

    unless page.nil?
      ro_page = Cms::Page.find(page.id)
      ro_page.readonly!
      data.page = ro_page
    end

    { data: data }
  end

  def check_handlebarjs_syntax
    begin
      render  
    rescue V8::Error => e
      Rails.logger.info(e)
      errors.add(:content, "Invalid View Helper syntax { #{e.message.split(':').first} }!")
    end
  end
end
