class CmsRenderers
  class << self
    def context(page, setup, system_content = nil)
      {
        page: page, 
        setup: setup,
        system_content: system_content,
        snippets: PageSnippetDrop.new(setup, page),
        whitelist: HTML::Pipeline::SanitizationFilter::WHITELIST.merge(
          :elements => %w(
            h1 h2 h3 h4 h5 h6 h7 h8 br b i strong em a pre code img tt
            div ins del sup sub p ol ul table blockquote dl dt dd
            kbd q samp var hr ruby rt rp li tr td th form input textarea span small
            style iframe
          ),
          :attributes => {
            'a' => ['href', 'class', 'data-slide'],
            'form' => ['action', 'method', 'class'],
            'input' => ['type', 'name', 'value', 'class'],
            'textarea' => ['rows', 'cols', 'name', 'class'],
            'img' => ['src', 'alt', 'data-src'],
            'span' => ['class'],
            'div' => ['itemscope', 'itemtype', 'style', 'data-interval', 
              'data-start-delay', 'data-href', 'data-width', 'data-show-faces', 
              'data-stream', 'data-header'],
            'iframe' => ['src', 'style', 'allowTransparency', 'frameborder', 'scrolling'],
            'style' => ['type'],
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
          },
          :protocols => {
            'a'   => {'href' => ['http', 'https', 'mailto', :relative, 'github-windows', 'github-mac']},
            'img' => {'src'  => ['http', 'https', :relative]},
            'iframe' => { 'src' => ['http', 'https', :relative]},
            'form' => { 'action' => ['http', 'https', :relative]}
          }
        )
      }    
    end
  
    def page(page, setup, system_content = nil)
      pipeline = HTML::Pipeline.new([
        LiquidFilter,
        HTML::Pipeline::AutolinkFilter
      ], self.context(page, setup, system_content))
      pipeline.call(page.layout)[:output].to_s.html_safe
    end
  
    def snippet(snippet, setup, page = nil)
      pipeline = HTML::Pipeline.new([
        LiquidFilter,
        HTML::Pipeline::AutolinkFilter
      ], self.context(page, setup))
      pipeline.call(snippet.content)[:output].to_s.html_safe
    end
  end
end