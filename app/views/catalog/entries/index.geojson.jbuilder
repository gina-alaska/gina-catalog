json.cache! @entries do
  json.type 'FeatureCollection'
  json.features @entries do |entry|
    json.cache! entry do
      json.type 'Feature'
      json.geometry RGeo::GeoJSON.encode(entry.bbox_centroid)
      json.properties do
        json.index ''
        json.id dom_id(entry)
        json.url catalog_entry_url(entry)
        json.title entry.title
        json.description entry.description.truncate(200)
        json.set! 'marker-color', entry.entry_type.color
        json.stroke entry.entry_type.color
      end
    end
  end
end
