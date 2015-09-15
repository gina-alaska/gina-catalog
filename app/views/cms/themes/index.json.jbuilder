json.array!(@cms_themes) do |cms_theme|
  json.extract! cms_theme, :id, :portal_id, :name, :css
  json.url cms_theme_url(cms_theme, format: :json)
end
