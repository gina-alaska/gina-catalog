module Glynx
  class MustacheFilter < HTML::Pipeline::Filter
    def initialize(*args)
      super(*args)

      @handlebars = Handlebars::Context.new
      register_helpers()
    end

    def entries(entries, scope, limit, block)
      if block.nil?
        block = limit
        limit = 10
      end
      limit ||= 10

      entries.published.limit(limit).map do |entry|
        block.fn(entry.mustache_context(current_page))
      end.join
    end

    def image_thumbnail_tag(image, type, options)
      size = options[:hash][:size] || '100x100'
      Handlebars::SafeString.new(
        ::ActionView::Base.new.attachment_image_tag(image, :file, type, *size.split('x'))
      )
    end

    def register_helpers
      @handlebars.register_helper(:parent_portal) do |this,block|
        block.fn(current_portal.parent.mustache_context) unless current_portal.parent.nil?
      end

      @handlebars.register_helper(:entries) do |this, context, block|
        limit = block[:hash][:limit]
        model = GlobalID::Locator.locate(context)
        if model.nil?
          ''
        else
          entries(model.entries, this, limit, block)
        end
      end

      @handlebars.register_helper(:newest_entries) do |this,context,block|
        if block.nil?
          block = context
          model = current_portal
        else
          model = GlobalID::Locator.locate(context)
        end

        limit = block[:hash][:limit]
        if model.nil?
          ''
        else
          entries(model.entries.active.newest, this, limit, block)
        end
      end

      @handlebars.register_helper(:updated_entries) do |this,context,block|
        if block.nil?
          block = context
          model = current_portal
        else
          model = GlobalID::Locator.locate(context)
        end

        limit = block[:hash][:limit]
        if model.nil?
          ''
        else
          entries(model.entries.active.recently_updated, this, limit, block)
        end
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
        image_thumbnail_tag(image, :limit, options)
      end

      # TODO: remove after this fixing all portals
      # adding in for compatibility with glynx 2.0
      @handlebars.register_helper(:thumb) do |this,image,options|
        image_thumbnail_tag(image, :limit, options)
      end

      @handlebars.register_helper(:fit) do |this,image,options|
        image_thumbnail_tag(image, :fit, options)
      end

      @handlebars.register_helper(:fill) do |this,image,options|
        image_thumbnail_tag(image, :fill, options)
      end

      @handlebars.register_helper(:image_attachments) do |this,block|
        current_page.cms_page_attachments.map(&:attachment).map do |image|
          block.fn(image.mustache_context(data.page))
        end.join if current_page
      end

      @handlebars.register_helper(:collections) do |this,block|
        collections = current_portal.collections.visible.order(name: :asc)

        if block[:hash][:name]
          collections = collections.where(name: block[:hash][:name])
        end
        if block[:hash][:limit]
          collections = collections.limit(block[:hash][:limit].to_i)
        end

        collections.map do |collection|
          block.fn(collection.mustache_context(data.page))
        end.join
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
      data.portal
    end

    def current_page
      data.page
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
