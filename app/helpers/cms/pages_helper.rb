module Cms::PagesHelper
  def page_collection
    current_portal.pages.roots.collect(&:self_and_descendants).flatten
  end

  def skip_collapse(page, tree_node)
    return false if page.nil?
    return true if page.ancestors.include?(tree_node) || page == tree_node
    false
  end
end
