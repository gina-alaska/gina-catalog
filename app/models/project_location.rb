class ProjectLocation < ActiveRecord::Base
  belongs_to :project
  belongs_to :location
  
  validates_uniqueness_of :location_id, :scope => :project_id
end
