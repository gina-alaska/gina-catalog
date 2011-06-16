class ProjectAgency < ActiveRecord::Base
  belongs_to :agency
  belongs_to :project
end
