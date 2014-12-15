class EntryAgency < ActiveRecord::Base
  belongs_to :entry
  belongs_to :agency
end
