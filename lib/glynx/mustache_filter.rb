module Glynx
  class MustacheFilter < HTML::Pipeline::Filter
    def initialize(*args)
      super(*args)

      @handlebars = Handlebars::Context.new
      register_helpers
    end

    def entries(entries, limit, block)
      if block.nil?
        block = limit
        limit = 10
      end
      limit ||= 10

      entries.published.limit(limit).map do |entry|
        block.fn(entry.mustache_context(current_page))
      end.join
    end

    def portals(portals, block)
      portals.map do |portal|
        block.fn(portal.mustache_context(current_page))
      end.join
    end

    def from_context(scope, context, block, default = nil)
      if block.nil?
        block = context
        context = scope
      end

      model = GlobalID::Locator.locate(context.gid) if context.respond_to? :gid

      [model || default, block]
    end

    def image_thumbnail_tag(image, type, options)
      size = options[:hash][:size] || '100x100'
      Handlebars::SafeString.new(
        ::ActionView::Base.new.attachment_image_tag(image, :file, type, *size.split('x'))
      )
    end

    def register_helpers
      @handlebars.register_helper(:parent_portal) do |this, context, block|
        model, block = from_context(this, context, block, current_portal)
        portals([model.parent], block) unless model.parent.nil?
      end

      @handlebars.register_helper(:child_portals) do |this, context, block|
        model, block = from_context(this, context, block, current_portal)
        portals(model.children, block)
      end

      @handlebars.register_helper(:sibling_portals) do |this, context, block|
        model, block = from_context(this, context, block, current_portal)
        portals(model.siblings, block)
      end

      @handlebars.register_helper(:entries) do |this, context, block|
        model, block = from_context(this, context, block, current_portal)
        entries(model.entries.active, block[:hash][:limit], block)
      end

      @handlebars.register_helper(:newest_entries) do |this, context, block|
        model, block = from_context(this, context, block, current_portal)
        entries(model.entries.active.newest, block[:hash][:limit], block)
      end

      @handlebars.register_helper(:updated_entries) do |this, context, block|
        model, block = from_context(this, context, block, current_portal)
        entries(model.entries.active.recently_updated, block[:hash][:limit], block)
      end

      @handlebars.register_helper(:pages) do |_this, block|
        current_portal.pages.roots.visible.map do |page|
          block.fn(page.mustache_context(data.page))
        end.join
      end

      @handlebars.register_helper(:find_page) do |_this, block|
        pages = current_portal.pages

        return unless block[:hash][:slug]

        page = pages.friendly.find(block[:hash][:slug])
        block.fn(page.mustache_context(data.page)) unless page.nil?
      end

      @handlebars.register_helper(:child_pages) do |this, context, block|
        page, block = from_context(this, context, block, current_page)
        children = page.children.visible

        if block[:hash][:limit]
          children = children.limit(block[:hash][:limit].to_i)
        end

        unless current_page.nil?
          children.map do |page|
            block.fn(page.mustache_context(page))
          end.join
        end
      end

      @handlebars.register_helper(:root_page) do |this, context, block|
        page, block = from_context(this, context, block, current_page)

        block.fn(page.root.mustache_context(page)) if !page.nil? && !page.root.nil?
      end

      @handlebars.register_helper(:parent_page) do |this, context, block|
        page, block = from_context(this, context, block, current_page)

        block.fn(page.parent.mustache_context(page)) if !page.nil? && !page.parent.nil?
      end

      @handlebars.register_helper(:thumbnail) do |this, image, options|
        model, options = from_context(this, image, options)
        image_thumbnail_tag(model, :limit, options)
      end

      # TODO: remove after this fixing all portals
      # adding in for compatibility with glynx 2.0
      @handlebars.register_helper(:thumb) do |this, image, options|
        model, options = from_context(this, image, options)

        image_thumbnail_tag(model, :limit, options)
      end

      @handlebars.register_helper(:fit) do |this, image, options|
        model, options = from_context(this, image, options)

        image_thumbnail_tag(model, :fit, options)
      end

      @handlebars.register_helper(:fill) do |this, image, options|
        model, options = from_context(this, image, options)

        image_thumbnail_tag(model, :fill, options)
      end

      @handlebars.register_helper(:image_attachments) do |this, context, block|
        page, block = from_context(this, context, block, current_page)

        if page
          page.attachments.images.map do |image|
            if block.keys.include? 'data'
              data = @handlebars.create_frame(block.data)
              data.first = (page.attachments.images.first == image)
            end

            block.fn(image.mustache_context(page), data: data)
          end.join
        end
      end

      @handlebars.register_helper(:content_for) do |this, context, block|
        set_content this.page, context, block.fn(current_page.mustache_context(data.page))

        ''
      end

      @handlebars.register_helper(:show_content_for) do |this, context|
        get_content(this.page, context)
      end

      @handlebars.register_helper(:collections) do |_this, block|
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
        lambda do |this, context, block|
          page, block = from_context(this, context, block, current_page)
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

    def set_content(page, name, value)
      RequestStore.store[:"content_for_#{page.slug.parameterize}_#{name.parameterize}"] = value
    end

    def get_content(page, name)
      RequestStore.store[:"content_for_#{page.slug.parameterize}_#{name.parameterize}"]
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
