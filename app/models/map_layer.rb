class MapLayer < ActiveRecord::Base
  searchkick word_start: [:name, :url, :type]

  validates :name, length: { maximum: 255 }, presence: true
  validates :map_url, length: { maximum: 255 }, presence: true
  validates :type, length: { maximum: 255 }
  validates :layers, length: { maximum: 255 }
  validates :projections, length: { maximum: 255 }

  has_many :entry_map_layers
  has_many :entries, through: :entry_map_layers

  scope :wms, -> { where(type: 'WmsLayer') }

  def supports?(*)
    # !self.projections.match(projection).nil? # save for tiled map layers
    fail 'MapLayer error: The STI model should implement the supports? method!'
  end
end
