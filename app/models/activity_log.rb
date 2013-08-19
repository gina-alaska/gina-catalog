class ActivityLog < ActiveRecord::Base
  attr_accessible :activity, :log, :performed_at, :user_id

  belongs_to :loggable, polymorphic: true
end
