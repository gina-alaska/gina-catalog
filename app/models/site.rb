class Site < ActiveRecord::Base
  acts_as_nested_set  
  
  validates :title, presence: true
  validates :acronym, presence: true
  
  has_many :urls, class_name: 'SiteUrl'
  
  scope :active, -> { }
  
  accepts_nested_attributes_for :urls, allow_destroy: true, reject_if: :reject_urls
 
 	validate :single_default_url

  def reject_urls(attributed)
    attributed['url'].blank?
  end

  def single_default_url
  	unless self.urls.where(default: true).count <= 1
  		errors.add(:urls, "can't have more than one default")
  	end
  end
end
