class Contact < ActiveRecord::Base
  validate :has_name_email_or_title
  validates :name, length: { maximum: 255 }
  validates :email, length: { maximum: 255 }
  validates :job_title, length: { maximum: 255 }
  validates :phone_number, length: { maximum: 255 }

  has_many :agency_contacts
  #has_many :agencies, through: :agency_contacts

  def has_name_email_or_title
  	if self.name.blank? and self.email.blank? and self.job_title.blank?
  		errors.add(:name, "Invalid Contact, must have at least a name, email, or job_title!")
  		errors.add(:email, "Invalid Contact, must have at least a name, email, or job_title!")
  		errors.add(:job_title, "Invalid Contact, must have at least a name, email, or job_title!")
  	end
  end
end
