class ProjectContact < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  
  validates_uniqueness_of :person_id, :scope => :project_id
end
