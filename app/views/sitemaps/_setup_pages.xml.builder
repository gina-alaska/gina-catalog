page.self_and_descendants.each do |descendent_page|
  page_xml.url {
    page_xml.loc(page_url(descendent_page.slug))      
  }
end
