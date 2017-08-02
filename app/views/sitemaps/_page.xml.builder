page.self_and_descendants.each do |descendent_page|
  page_xml.url do
    page_xml.loc(page_url(descendent_page.slug))
    page_xml.lastmod(descendent_page.updated_at.strftime("%F"))
    page_xml.changefreq("monthly")
  end
end
