class Contact < ActiveRecord::Base
  before_destroy :check_if_deletable, prepend: true
  
  validate :has_name_email_or_title
  validates :name, length: { maximum: 255 }
  validates :email, length: { maximum: 255 }
  validates :job_title, length: { maximum: 255 }
  validates :phone_number, length: { maximum: 255 }

  has_many :agency_contacts
  has_many :agencies, through: :agency_contacts
  
  has_many :entry_contacts
  has_many :entries, through: :entry_contacts
  
  def has_name_email_or_title
  	if self.name.blank? and self.email.blank? and self.job_title.blank?
  		errors.add(:name, "must have either a name, email, or job title!")
  		errors.add(:email, "must have either a name, email, or job title!")
  		errors.add(:job_title, "must have either a name, email, or job title!")
  	end
  end

  def deletable?
    self.entries.empty?
  end
  
  def not_deletable_reason
    if !self.entries.empty?
      "belongs to one or more catalog records"
    end
  end

  private 
  
  def check_if_deletable
    if !deletable?
      errors.add(:base, "Cannot delete contact, #{not_deletable_reason}")
      false
    end
  end
  
end
