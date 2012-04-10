class AgencyPerson < ActiveRecord::Base
  belongs_to :agency
  belongs_to :person
end
