class Collection < ActiveRecord::Base
  include LegacyConcerns
  include MustacheConcerns

  validates :name, length: { maximum: 255 }

  belongs_to :portal

  has_many :entry_collections, dependent: :delete_all
  has_many :entries, through: :entry_collections
  acts_as_list scope: :portal

  scope :used_by_portal, ->(portal) {
    where(portal: portal)
  }

  scope :visible, -> {
    where(hidden: false)
  }

  # this is a hack, searchkick should handle this
  def load_entries
    entries.load_target unless entries.loaded?
  end
end
