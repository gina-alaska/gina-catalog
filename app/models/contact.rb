class Contact < ActiveRecord::Base
  include EntryDependentConcerns
    
  validate :has_name_email_or_title
  validates :name, length: { maximum: 255 }
  validates :email, length: { maximum: 255 }
  validates :job_title, length: { maximum: 255 }
  validates :phone_number, length: { maximum: 255 }
  
  has_many :entry_contacts
  has_many :entries, through: :entry_contacts

  def has_name_email_or_title
  	if self.name.blank? and self.email.blank? and self.job_title.blank?
  		errors.add(:name, "must have either a name, email, or job title!")
  		errors.add(:email, "must have either a name, email, or job title!")
  		errors.add(:job_title, "must have either a name, email, or job title!")
  	end
  end
  
end
