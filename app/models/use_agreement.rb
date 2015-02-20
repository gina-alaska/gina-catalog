class UseAgreement < ActiveRecord::Base
  include EntryDependentConcerns

  belongs_to :portal
  has_many :entries

  validates_presence_of :title
  validates :title, length: { maximum: 255 }
  validates_presence_of :body

  before_destroy :deletable?

  scope :used_by_portal, ->(portal) {
    where(portal: portal)
  }

  def deletable?
    entries.empty?
  end

  def archive
    self.archived_at = Time.zone.now if archived_at.nil?
  end

  def unarchive
    self.archived_at = nil
  end

  def archived
    !archived_at.blank?
  end

  def archived=(value)
    value.to_i == 1 ? archive : unarchive
  end
end
