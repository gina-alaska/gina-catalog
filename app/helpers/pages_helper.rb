module PagesHelper  
  def render_cms_content(page, setup)
    CmsRenderers.page(page, setup)
  end
  
  def render_snippet_content(snippet, setup)
    CmsRenderers.snippet(snippet, setup)
  end
end
