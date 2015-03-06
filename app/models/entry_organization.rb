class EntryOrganization < ActiveRecord::Base
  belongs_to :entry, touch: true
  belongs_to :organization

  validates :organization_id, uniqueness: { scope: [:organization_id, :primary, :funding] }

  scope :primary, -> { where(primary: true) }
  scope :funding, -> { where(funding: true) }
  scope :other, -> { where(funding: false, primary: false) }
end
