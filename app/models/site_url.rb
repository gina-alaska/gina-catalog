class SiteUrl < ActiveRecord::Base
  belongs_to :site
  
  validates :url, presence: true
  # validate :single_default_site_url
  
  scope :default_url, -> { where(default: true) }
  
  # def single_default_site_url
  #   if self.default and SiteUrl.where(default:true, site: self.site).where.not(id: self.id).count > 0
  #     errors.add(:default, 'can only be true for one url per site')
  #   end
  # end
end
