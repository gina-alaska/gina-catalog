json.array!(@cms_attachments) do |cms_attachment|
  json.extract! cms_attachment, :id, :name, :description, :file_id, :file_filename, :file_size, :file_content_type, :portal_id
  json.thumbnail_url attachment_url(cms_attachment, :file, :fill, 100, 100)
  json.image_url attachment_url(cms_attachment, :file)
  json.url cms_attachment_url(cms_attachment, format: :json)
end
