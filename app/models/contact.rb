class Contact < ActiveRecord::Base
  include EntryDependentConcerns
  searchkick

  validate :name_email_or_title?
  validates :name, length: { maximum: 255 }
  validates :email, length: { maximum: 255 }
  validates :job_title, length: { maximum: 255 }
  validates :phone_number, length: { maximum: 255 }

  has_many :entry_contacts
  has_many :entries, through: :entry_contacts

  has_many :entry_portals, through: :entries

  scope :used_by_portal, ->(portal) {
    includes(:entry_portals).references(:entry_portals).where('entry_portals.id = ? or contacts.created_at >= ?', portal.id, 1.week.ago)
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
end
