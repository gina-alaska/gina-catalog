class ContactInfo < ActiveRecord::Base
  belongs_to :catalog
  belongs_to :activity_log
  belongs_to :setup
  
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :usage_description

  scope :created_between,  ->(starts_at, ends_at) {
    unless starts_at.nil? and ends_at.nil?
      data = self
      unless starts_at.nil?
        starts_at = starts_at.beginning_of_day
      end
      unless ends_at.nil?
        ends_at = ends_at.end_of_day
      end
      data = data.where("contact_infos.created_at >= ?", starts_at)
      data = data.where("contact_infos.created_at <= ?", ends_at)

      data
    else 
      where("contact_infos.created_at <= ?", Time.zone.now)
    end
  }

  scope :current_setup, ->(setup) {
    joins(:catalog).where("catalog.owner_setup_id = ? or contact_infos.setup_id = ?", setup.id, setup.id).uniq
  }

  scope :top_downloads, lambda {
    data = self
    data = data.select("contact_infos.catalog_id, count(*) as download_count").group("contact_infos.catalog_id").order('download_count DESC').limit(10)

    data
  }
  
  def offer_key
    UUIDTools::UUID.md5_create(UUIDTools::UUID_OID_NAMESPACE, "#{self.id}|#{self.name}|#{self.email}|#{self.usage_description}").to_s
  end
end
