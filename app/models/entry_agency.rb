class EntryAgency < ActiveRecord::Base
  validates :entry_id, numericality: { only_integer: true }
  validates :agency_id, numericality: { only_integer: true }
end
