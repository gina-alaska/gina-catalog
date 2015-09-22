json.array!(@cms_layouts) do |cms_layout|
  json.extract! cms_layout, :id, :name, :portal_id, :content
  json.url cms_layout_url(cms_layout, format: :json)
end
