xml.instruct!
xml.urlset("xmlns"=>"http://www.sitemaps.org/schemas/sitemap/0.9") {
  @setup_pages.each do |page|
    render 'setup_pages', page_xml: xml, page: page
  end
}