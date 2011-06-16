class ProjectTheme < ActiveRecord::Base
  belongs_to :theme
  belongs_to :project
end
