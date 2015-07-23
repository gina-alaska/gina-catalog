class EntryOrganization < ActiveRecord::Base
  belongs_to :entry, touch: true
  belongs_to :organization

  validates :organization_id, uniqueness: { scope: [:entry_id, :primary, :funding] }

  scope :primary, -> { where(primary: true) }
  scope :funding, -> { where(funding: true) }
  scope :other, -> { where(funding: false, primary: false) }
  scope :owner_portal, ->(portal) { joins(entry: :owner_portal).references(:portals).where(portals: { id: portal.id }) }
end
