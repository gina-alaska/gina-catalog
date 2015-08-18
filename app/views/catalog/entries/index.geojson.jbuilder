json.cache! @entries do
  json.type 'FeatureCollection'
  json.features @entries do |entry|
    entry.bboxes.each do |bbox|
      json.cache! entry do
        json.type 'Feature'
        json.geometry RGeo::GeoJSON.encode(bbox.centroid)
        json.properties do
          json.index ''
          json.id dom_id(entry)
          json.url entry_url(entry)
          json.title entry.title
          json.description entry.description.truncate(200)
          json.set! 'marker-color', entry.entry_type.color
          json.stroke entry.entry_type.color
        end
      end
    end
  end
end
