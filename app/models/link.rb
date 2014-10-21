class Link < ActiveRecord::Base
  CATEGORIES = ['Website', 'Download', 'Report', 'Shape File', 'WMS', 'WCS', 'WFS', 'KML', 'Layer', 'Metadata', 'PDF', 'Map Service']

  belongs_to :entries

  validates_length_of :display_text, maximum: 255
  validates_length_of :url, in: 11..255, message: "%{value} is not a valid url"
  validates_inclusion_of :category, in: CATEGORIES, message: "%{value} is not a valid category"
end
