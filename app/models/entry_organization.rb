class EntryOrganization < ActiveRecord::Base
  belongs_to :entry
  belongs_to :organization

  scope :primary, -> { where(primary: true) }
  scope :funding, -> { where(funding: true) }
end
