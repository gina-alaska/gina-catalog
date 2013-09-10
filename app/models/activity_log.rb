class ActivityLog < ActiveRecord::Base
  attr_accessible :activity, :log, :user_id
  
  serialize :log

  belongs_to :loggable, polymorphic: true
end
