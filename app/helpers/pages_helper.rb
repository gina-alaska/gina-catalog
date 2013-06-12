module PagesHelper  
  def render_cms_content(page, setup, &block)
    system_content = capture(&block) if block_given?
    CmsRenderers.page(page, setup, system_content)
  end
  
  def render_snippet_content(snippet, setup)
    CmsRenderers.snippet(snippet, setup)
  end
end
