json.array!(@cms_attachments) do |cms_attachment|
  json.extract! cms_attachment, :id, :name, :description, :file_id, :file_filename, :file_size, :file_content_type, :portal_id
  json.url cms_attachment_url(cms_attachment, format: :json)
end
