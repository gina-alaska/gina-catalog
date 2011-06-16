class ProjectGeolocation < ActiveRecord::Base
  belongs_to :project
  belongs_to :geolocation
end
