class UseAgreement < ActiveRecord::Base
  include EntryDependentConcerns
  include LegacyConcerns
  include ArchiveConcerns

  belongs_to :portal
  has_many :entries

  validates :title, presence: true
  validates :title, length: { maximum: 255 }
  validates :body, presence: true

  before_destroy :deletable?

  scope :used_by_portal, ->(portal) {
    where(portal: portal)
  }

  def deletable?
    entries.empty?
  end
end
