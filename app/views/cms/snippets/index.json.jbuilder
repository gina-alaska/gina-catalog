json.array!(@cms_snippets) do |cms_snippet|
  json.extract! cms_snippet, :id, :name, :slug, :content, :portal_id
  json.url cms_snippet_url(cms_snippet, format: :json)
end
