module Cms::PagesHelper
  def page_collection
    current_portal.pages.roots.collect(&:self_and_descendants).flatten
  end

  def skip_collapse(page, tree_node)
    return false if page.nil?
    return true if page.ancestors.include?(tree_node) || page == tree_node
    false
  end

  def disabled_up(page)
    page.siblings_before.empty? ? 'disabled' : ''
  end

  def disabled_down(page)
    page.siblings_after.empty? ? 'disabled' : ''
  end

  def render_into_cms(page, &block)
    page.content = capture(&block) if block_given?
    page.render
  end

  def page_type_css(page)
    return 'muted' if page.hidden?
    return 'danger' if page.system_page?
    ''
  end
end
