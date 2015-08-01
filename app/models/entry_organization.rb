class EntryOrganization < ActiveRecord::Base
  belongs_to :entry, touch: true
  belongs_to :organization

  validates :organization_id, uniqueness: { scope: [:entry_id, :primary, :funding] }

  scope :primary, -> { where(primary: true) }
  scope :funding, -> { where(funding: true) }
  scope :other, -> { where(funding: false, primary: false) }
  scope :owner_portal, ->(portal) { joins(entry: :owner_portal).references(:portals).where(portals: { id: portal.id }) }

  include PublicActivity::Model

  tracked owner: proc { |controller, _model| controller.send(:current_user) },
          entry_id: :entry_id,
          parameters: :activity_params

  def to_s
    organization.name
  end

  def activity_params
    { organization: organization.to_global_id.to_s  }
  end
end
