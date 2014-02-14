class ActivityLog < ActiveRecord::Base
  attr_accessible :activity, :log, :user_id, :user, :contact_info
  
  serialize :log

  belongs_to :loggable, polymorphic: true
  belongs_to :user
  
  has_one :contact_info
  
  validates :activity, presence: true
  
  def unknown_agencies
    agencies = []
    log[:errors].each do |url, error|
      if error[:agencies]
        agencies << error[:agencies]
      end
    end
    if agencies.any?
      agencies.flatten!.uniq!.reject!(&:blank?)
      agencies.reject! do |a| 
        results = Agency.search do
          any_of do
            with(:name,a)
            with(:alias_names, a)
          end
        end
        results.total > 0
      end
    end
    agencies
  end
  
end
