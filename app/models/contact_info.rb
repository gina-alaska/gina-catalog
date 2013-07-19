class ContactInfo < ActiveRecord::Base
  belongs_to :catalog
  belongs_to :setup
  
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :usage_description

  scope :created_between,  ->(starts_at, ends_at) {
    unless starts_at.nil? and ends_at.nil?
      data = self
      unless starts_at.nil?
        starts_at = starts_at.beginning_of_day
        data = data.where("contact_infos.created_at >= ?", starts_at)
      end
      unless ends_at.nil?
        ends_at = ends_at.end_of_day
        data = data.where("contact_infos.created_at <= ?", ends_at)
      end

      data
    else 
      where("contact_infos.created_at <= ?", Time.zone.now)
    end
  }
end
