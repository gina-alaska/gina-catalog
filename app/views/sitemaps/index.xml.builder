xml.instruct!
xml.urlset("xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9") do
  @pages.each do |page|
    render 'page', page_xml: xml, page: page
  end
end
