json.array! @iso_topics do |iso_topic|
  json.id iso_topic.id
  json.long_name_with_code iso_topic.long_name_with_code
end
