class ContactInfo < ActiveRecord::Base
  belongs_to :catalog
  
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :usage_description

  scope :created_between,  ->(starts_at, ends_at) {
    unless starts_at.blank? and ends_at.blank?
      data = self
      unless starts_at.blank?
        starts_at = Time.parse(starts_at).beginning_of_day
        data = data.where("contact_infos.created_at >= ?", starts_at)
      end
      unless ends_at.blank?
        ends_at = Time.parse(ends_at).end_of_day
        data = data.where("contact_infos.created_at <= ?", ends_at)
      end

      data
    else 
      where("contact_infos.created_at <= ?", Time.now)
    end
  }
end
