class EntryContact < ActiveRecord::Base
  belongs_to :entry, touch: true
  belongs_to :contact

  validates :contact_id, uniqueness: { scope: [:entry_id, :primary] }

  scope :primary, -> { where(primary: true) }
  scope :other, -> { where(primary: false) }
  scope :owner_portal, ->(portal) { joins(entry: :owner_portal).references(:portals).where(portals: { id: portal.id }) }

  include PublicActivity::Model

  tracked owner: proc { |controller, _model| controller.send(:current_user) },
          entry_id: :entry_id,
          parameters: :activity_params

  def to_s
    contact.name
  end

  def activity_params
    { contact: contact.to_global_id.to_s }
  end
end
