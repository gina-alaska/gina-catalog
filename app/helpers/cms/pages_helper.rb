module Cms::PagesHelper
  def page_collection
    current_portal.pages.roots.collect(&:self_and_descendants).flatten
  end
end
