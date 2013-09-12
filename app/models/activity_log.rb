class ActivityLog < ActiveRecord::Base
  attr_accessible :activity, :log, :user_id
  
  serialize :log

  belongs_to :loggable, polymorphic: true
  
  
  def unknown_agencies
    agencies = []
    log[:errors].each do |url, error|
      if error[:agencies]
        agencies << error[:agencies]
      end
    end
    agencies.flatten!.uniq!.reject(&:blank?)
  end
  
end
