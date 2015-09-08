json.array!(@cms_pages) do |cms_page|
  json.extract! cms_page, :id, :title, :slug, :content, :portal_id, :cms_layout_id
  json.url cms_page_url(cms_page, format: :json)
end
