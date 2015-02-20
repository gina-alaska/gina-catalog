class EntryOrganization < ActiveRecord::Base
  belongs_to :entry, touch: true
  belongs_to :organization

  scope :primary, -> { where(primary: true) }
  scope :funding, -> { where(funding: true) }
end
