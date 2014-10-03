class ActivityLog < ActiveRecord::Base
  attr_accessible :activity, :log, :user_id, :user, :contact_info, :setup, :catalog, :loggable, :setup_id
  
  serialize :log

  belongs_to :loggable, polymorphic: true
  belongs_to :user
  belongs_to :setup
  belongs_to :catalog
  belongs_to :contact_info
  
  # belongs_to :contact_info
  
  validates :activity, presence: true
  
  scope :downloads, -> { where(activity: 'Download') }
  
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
