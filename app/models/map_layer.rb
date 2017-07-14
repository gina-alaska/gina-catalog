class MapLayer < ActiveRecord::Base
  include EntryDependentConcerns

  searchkick word_start: [:name, :url, :type]

  validates :name, length: { maximum: 255 }, presence: true
  validates :map_url, length: { maximum: 255 }, presence: true
  validates :type, length: { maximum: 255 }
  validates :layers, length: { maximum: 255 }
  validates :projections, length: { maximum: 255 }

  has_many :entry_map_layers
  has_many :entries, through: :entry_map_layers
  belongs_to :portal

  scope :wms, -> { where(type: 'WmsLayer') }

  def supports?(*)
    fail 'MapLayer error: The STI model should implement the supports? method!'
  end

  def layer_type
    fail 'MapLayer error: The layer type needs to be defined in the STI model'
  end

  def leaflet_options
    {
      type: layer_type,
      name: name,
      url: map_url,
      layers: layers,
      projections: projections
    }
  end
end
