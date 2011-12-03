class OldLink < ActiveRecord::Base
  CATEGORIES = ['Website', 'Report', 'Shape File', 'WMS', 'WCS', 'WFS', 'KML', 'Layer', 'Metadata']
  set_primary_key :id

  belongs_to :linkable, :polymorphic => true

  validates_length_of :display_text, :in => 3..255
  validates_length_of :url, :in => 11..255
  validates_inclusion_of :category, :in => CATEGORIES, :message => "{{value}} is not a valid category"
end
