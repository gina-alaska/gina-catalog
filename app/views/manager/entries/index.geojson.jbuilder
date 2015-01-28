json.type "FeatureCollection"

json.features @entries.map(&:bboxes).flatten do |bbox|
  json.type 'Feature'
  json.geometry RGeo::GeoJSON.encode(bbox.centroid)
  json.properties do
    json.index ''
    json.id dom_id(bbox.boundable.entry)
    json.title bbox.boundable.entry.title
    json.set! 'marker-color', bbox.boundable.entry.entry_type.color
    json.stroke bbox.boundable.entry.entry_type.color
  end
end
