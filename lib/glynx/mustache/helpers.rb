module Glynx
  module Mustache
    class Helpers
      attr_accessor :current_portal, :current_page
      def initialize(page, portal, handlebars)
        @handlebars = handlebars
        @current_page = page
        @current_portal = portal
      end

      def parent_portal_helper(this, context, block)
        model, block = from_context(this, context, block, current_portal)
        mustache_portals([model.parent], block) unless model.parent.nil?
      end

      def child_portals_helper(this, context, block)
        model, block = from_context(this, context, block, current_portal)
        mustache_portals(model.children, block)
      end

      def sibling_portals_helper(this, context, block)
        model, block = from_context(this, context, block, current_portal)
        mustache_portals(model.siblings, block)
      end

      def entries_helper(this, context, block)
        model, block = from_context(this, context, block, current_portal)
        mustache_entries(model.entries.active, block[:hash][:limit], block)
      end

      def newest_entries_helper(this, context, block)
        model, block = from_context(this, context, block, current_portal)
        mustache_entries(model.entries.active.newest, block[:hash][:limit], block)
      end

      def updated_entries_helper(this, context, block)
        model, block = from_context(this, context, block, current_portal)
        mustache_entries(model.entries.active.recently_updated, block[:hash][:limit], block)
      end

      def pages_helper(_this, block)
        current_portal.pages.roots.visible.map do |page|
          block.fn(page.mustache_context(current_page))
        end.join
      end

      def find_page_helper(_this, block)
        return unless block[:hash][:slug]

        pages = current_portal.pages
        page = pages.friendly.find(block[:hash][:slug])
        block.fn(page.mustache_context(current_page)) unless page.nil?
      end

      def child_pages_helper(this, context, block)
        return if current_page.nil?

        page, block = from_context(this, context, block, current_page)
        children = page.children.visible

        if block[:hash][:limit]
          children = children.limit(block[:hash][:limit].to_i)
        end

        children.map do |child_page|
          block.fn(child_page.mustache_context(child_page))
        end.join
      end

      def root_page_helper(this, context, block)
        page, block = from_context(this, context, block, current_page)

        block.fn(page.root.mustache_context(page)) if !page.nil? && !page.root.nil?
      end

      def parent_page_helper(this, context, block)
        page, block = from_context(this, context, block, current_page)

        block.fn(page.parent.mustache_context(page)) if !page.nil? && !page.parent.nil?
      end

      def thumbnail_helper(this, image, options)
        model, options = from_context(this, image, options)
        image_thumbnail_tag(model, :limit, options)
      end

      def fit_helper(this, image, options)
        model, options = from_context(this, image, options)

        image_thumbnail_tag(model, :fit, options)
      end

      def fill_helper(this, image, options)
        model, options = from_context(this, image, options)

        image_thumbnail_tag(model, :fill, options)
      end

      def image_attachments_helper(this, context, block)
        page, block = from_context(this, context, block, current_page)

        return unless page

        page.attachments.images.map do |image|
          if block.keys.include? 'data'
            data = @handlebars.create_frame(block.data)
            data.first = (page.attachments.images.first == image)
          end

          block.fn(image.mustache_context(page), data: data)
        end.join
      end

      def content_for_helper(this, context, block)
        set_content this.page, context, block.fn(current_page.mustache_context(current_page))

        ''
      end

      def show_content_for_helper(this, context)
        get_content(this.page, context)
      end

      def collections_helper(_this, block)
        collections = current_portal.collections.visible.order(name: :asc)

        if block[:hash][:name]
          collections = collections.where(name: block[:hash][:name])
        end
        if block[:hash][:limit]
          collections = collections.limit(block[:hash][:limit].to_i)
        end

        collections.map do |collection|
          block.fn(collection.mustache_context(current_page))
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

      protected

      def mustache_entries(entries, limit, block)
        if block.nil?
          block = limit
          limit = 10
        end
        limit ||= 10

        entries.published.limit(limit).map do |entry|
          block.fn(entry.mustache_context(current_page))
        end.join
      end

      def mustache_portals(portals, block)
        portals.map do |portal|
          block.fn(portal.mustache_context(current_page))
        end.join
      end

      def image_thumbnail_tag(image, type, options)
        size = options[:hash][:size] || '100x100'
        Handlebars::SafeString.new(
          ::ActionView::Base.new.attachment_image_tag(image, :file, type, *size.split('x'))
        )
      end

      def set_content(page, name, value)
        RequestStore.store[:"content_for_#{page.slug.parameterize}_#{name.parameterize}"] = value
      end

      def get_content(page, name)
        RequestStore.store[:"content_for_#{page.slug.parameterize}_#{name.parameterize}"]
      end
    end
  end
end
