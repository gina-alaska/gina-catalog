json.array! @tags do |tag|
  json.id tag.name
  json.name tag.name
end
