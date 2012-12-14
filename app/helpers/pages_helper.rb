module PagesHelper
  def render_cms_content(page, setup)
    context = {
      page: page, 
      setup: setup,
      whitelist: HTML::Pipeline::SanitizationFilter::WHITELIST.merge(
        :attributes => {
          'a' => ['href', 'class', 'data-slide'],
          'img' => ['src', 'alt'],
          'div' => ['itemscope', 'itemtype'],
          :all => ['abbr', 'accept', 'accept-charset',
                    'accesskey', 'action', 'align', 'alt', 'axis',
                    'border', 'cellpadding', 'cellspacing', 'char',
                    'charoff', 'charset', 'checked', 'cite',
                    'clear', 'cols', 'colspan', 'color',
                    'compact', 'coords', 'datetime', 'dir',
                    'disabled', 'enctype', 'for', 'frame',
                    'headers', 'height', 'hreflang',
                    'hspace', 'ismap', 'label', 'lang',
                    'longdesc', 'maxlength', 'media', 'method',
                    'multiple', 'name', 'nohref', 'noshade',
                    'nowrap', 'prompt', 'readonly', 'rel', 'rev',
                    'rows', 'rowspan', 'rules', 'scope',
                    'selected', 'shape', 'size', 'span',
                    'start', 'summary', 'tabindex', 'target',
                    'title', 'type', 'usemap', 'valign', 'value',
                    'vspace', 'width', 'itemprop', 'id', 'class']
        }
      )
    }
    
    pipeline = HTML::Pipeline.new([
      LiquidFilter,
      HTML::Pipeline::AutolinkFilter,
      HTML::Pipeline::SanitizationFilter
    ], context)
    
    pipeline.call(page.layout)[:output].to_s.html_safe
  end
  
  def render_liquid_content(layout, page, setup)
    Liquid::Template.parse(layout.content).render({ 'page' => page, 'setup' => setup})
  end
end
