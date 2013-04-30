class ContactInfo < ActiveRecord::Base
  belongs_to :catalog
  
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :usage_description

  scope :created_between,  ->(starts_at, ends_at) {
    unless starts_at.blank? and ends_at.blank?
      data = self
      unless starts_at.blank?
        data = data.where("created_at >= ?", starts_at)
      end
      unless ends_at.blank?
        data = data.where("created_at <= ?", ends_at)
      end

      data
    else 
      where("created_at <= ?", Time.now)
    end
  }
end
