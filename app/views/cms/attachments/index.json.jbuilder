json.array!(@cms_attachments) do |cms_attachment|
  json.extract! cms_attachment, :id, :name, :description, :file_id, :file_filename, :file_size, :file_content_type, :portal_id
  json.filename truncate cms_attachment.file_filename
  if cms_attachment.image?
    json.preview_url attachment_url(cms_attachment, :file, :fill, 200, 100)
  else
    json.preview_url asset_url('document.png')
  end
  json.age time_ago_in_words(cms_attachment.created_at)
  json.human_filesize number_to_human_size(cms_attachment.file_size)
  json.link_url attachment_url(cms_attachment, :file)
  json.url cms_attachment_url(cms_attachment, format: :json)
end
