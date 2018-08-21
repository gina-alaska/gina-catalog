class Contact < ActiveRecord::Base
  include EntryDependentConcerns
  include LegacyConcerns

  searchkick word_start: %i[name email job_title]

  validate :name_email_or_title?
  validates :name, length: { maximum: 255 }
  validates :email, length: { maximum: 255 }, uniqueness: true, allow_blank: true
  validates :job_title, length: { maximum: 255 }
  validates :phone_number, length: { maximum: 255 }

  has_many :entry_contacts
  has_many :entries, through: :entry_contacts

  has_many :entry_portals, through: :entries

  scope :used_by_portal, ->(portal) {
    query = 'entry_portals.portal_id = :portal_id or contacts.created_at >= :start_date'
    includes(:entry_portals).references(:entry_portals).where(query, portal_id: portal.id, start_date: 1.week.ago)
  }

  def name_email_or_title?
    return if name.present? || email.present? || job_title.present?
    errors.add(:name, 'must have either a name, email, or job title!')
    errors.add(:email, 'must have either a name, email, or job title!')
    errors.add(:job_title, 'must have either a name, email, or job title!')
  end

  def name_with_email
    "#{name} (#{email})"
  end

  # check for portal
  def check_portal(portal)
    self.entry_portals.include?(portal.id)
  end
end
