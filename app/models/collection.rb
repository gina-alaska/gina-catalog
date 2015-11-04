class Collection < ActiveRecord::Base
  include LegacyConcerns
  include MustacheConcerns

  validates :name, length: { maximum: 255 }

  belongs_to :portal

  has_many :entry_collections, dependent: :delete_all
  has_many :entries, through: :entry_collections

  scope :used_by_portal, ->(portal) {
    where(portal: portal)
  }

  scope :visible, -> {
    where(hidden: false).pluck(:name)
  }

  def mustache_context(*args)
    context = super(*args)

    context['collection'] = to_global_id.to_s

    context
  end
end
