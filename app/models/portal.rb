class Portal < ActiveRecord::Base
  acts_as_nested_set  
  
  has_many :urls, class_name: 'PortalUrl'
  has_one :default_url, -> { where default: true }, class_name: 'PortalUrl'
  
  has_many :permissions
  has_many :invitations
  has_many :users, through: :permissions
  has_many :activity_logs, as: :loggable
  
  has_many :entry_portals
  has_many :entries, through: :entry_portals
  
  scope :active, -> { }
  
  validates :title, presence: true
  validates :acronym, presence: true
  validate :single_default_url
  
  accepts_nested_attributes_for :urls, allow_destroy: true, reject_if: :blank_url
 
   # validate :single_default_url

  def blank_url(attributed)
    attributed['url'].blank?
  end
  
  # def default_url
  #   self.urls.default_url.first.url
  # end
  
  def default_url_count
    self.urls.inject(0) { |c,v| c+=1 if v.default; c }
  end

  def single_default_url
    if default_url_count > 1
      errors.add(:urls, "cannot have more than one default url")
    end
  end
end
