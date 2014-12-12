class EntryAgency < ActiveRecord::Base
  belongs_to :entry
  belongs_to :agency
  
  scope :primary, -> { where(primary: true) }
  scope :funding, -> { where(funding: true) }
end
