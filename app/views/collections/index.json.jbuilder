json.array! @collections do |collection|
  json.extract! collection, :id, :name
end
