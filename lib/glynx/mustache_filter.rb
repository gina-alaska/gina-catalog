module Glynx
  class MustacheFilter < HTML::Pipeline::Filter
    def initialize(*args)
      super(*args)
      
      @handlebars = Handlebars::Context.new
      @page = data.page
      register_helpers()
    end

    def register_helpers
      @handlebars.register_helper(:newest_entries) do |this,limit,block|
        if block.nil?
          block = limit
          limit = 10
        end
        limit ||= 10

        current_portal.entries.active.newest.limit(limit).map do |entry|
          block.fn(entry.mustache_context(@page))
        end.join
      end

      @handlebars.register_helper(:latest_entries) do |this,limit,block|
        if block.nil?
          block = limit
          limit = 10
        end
        limit ||= 10

        current_portal.entries.active.recently_updated.limit(limit).map do |entry|
          block.fn(entry.mustache_context(@page))
        end.join
      end

      @handlebars.register_helper(:pages) do |this,block|
        current_portal.pages.roots.visible.map do |page|
          block.fn(page.mustache_context(data.page))
        end.join
      end

      @handlebars.register_helper(:child_pages) do |this,block|
        current_page.children.visible.map do |page|
          block.fn(page.mustache_context(data.page))
        end.join unless current_page.nil?
      end

      @handlebars.register_helper(:root_page) do |this,block|
        block.fn(current_page.root.mustache_context(data.page)) if !current_page.nil? && !current_page.root?
      end

      @handlebars.register_helper(:parent_page) do |this,block|
        block.fn(current_page.parent.mustache_context(data.page)) if !current_page.nil? && !current_page.parent.nil?
      end

      @handlebars.register_helper(:thumbnail) do |this,image,options|
        size = options[:hash][:size]
        Handlebars::SafeString.new(
          ::ActionView::Base.new.attachment_image_tag(image, :file, :limit, *size.split('x'))
        )
      end

      @handlebars.register_helper(:fit) do |this,image,options|
        size = options[:hash][:size]
        Handlebars::SafeString.new(
          ::ActionView::Base.new.attachment_image_tag(image, :file, :fit, *size.split('x'))
        )
      end

      @handlebars.register_helper(:fill) do |this,image,options|
        size = options[:hash][:size]
        Handlebars::SafeString.new(
          ::ActionView::Base.new.attachment_image_tag(image, :file, :fill, *size.split('x'))
        )
      end

      @handlebars.register_helper(:image_attachments) do |this,block|
        current_page.cms_page_attachments.map(&:attachment).map do |image|
          block.fn(image.mustache_context(data.page))
        end.join if current_page
      end

      @handlebars.partial_missing do |name|
        lambda do |this,context,options|
          current_portal.snippets.friendly.find(name).render({ data: data })
        end
      end
    end

    def data
      context[:data]
    end

    def current_portal
      context[:data].portal
    end

    def current_page
      context[:data].page
    end

    def clean_context
      data.marshal_dump.each_with_object({}) do |k,c|
        if k.last.respond_to? :mustache_context
          c[k.first] = k.last.mustache_context(data.page)
        elsif k.last.respond_to? :attributes
          c[k.first] = k.last.attributes
        else
          c[k.first] = k.last
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
