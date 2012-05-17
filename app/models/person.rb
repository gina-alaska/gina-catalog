class Person < ActiveRecord::Base
  has_many :agency_people
  has_many :agencies, :through => :agency_people, :dependent => :destroy
  
  has_many :project_contacts
  has_many :projects, :through => :project_contacts, :dependent => :destroy
  
  has_many :addresses, :dependent => :destroy
  
  has_many :phone_numbers
  
  validates_presence_of   :first_name
  validates_presence_of   :last_name
#  validates_associated    :phone_numbers, :addresses
  
  searchable do
    text :first_name
    text :last_name
    text :email
    text :agency do
      agencies.map{|a| [a.name, a.acronym]}
    end
  
    integer :id
  end  
  
  def full_name
    [self.last_name, self.first_name].compact.join(', ')
  end
  
  def contact_string
    cnt = "#{first_name} #{last_name}"
    cnt << " <#{email}" unless email.nil?
    cnt
  end
  
  def work_phone
    self.phone_numbers.each do |pn|
      return pn if pn.name == 'work'
    end
    nil
  end

  def work_phone=(digits)
    pn = self.work_phone
    pn = self.phone_numbers.build({ :name => 'work' }) if !pn
    pn.digits = digits

    pn.save!
  end

  def alt_phone
    self.phone_numbers.each do |pn|
      return pn if pn.name == 'alt'
    end
    nil
  end

  def alt_phone=(digits)
    pn = self.alt_phone
    pn = self.phone_numbers.build({ :name => 'alt' }) if !pn
    pn.digits = digits

    pn.save!
  end

  def mobile_phone
    self.phone_numbers.each do |pn|
      return pn if pn.name == 'mobile'
    end
    nil
  end
  
  def mobile_phone=(digits)
    pn = self.mobile_phone
    pn = self.phone_numbers.build({ :name => 'mobile' }) if !pn
    pn.digits = digits

    pn.save!
  end

  def as_json(*opts)
    {
      :id => self.id,
      :first_name => self.first_name,
      :last_name => self.last_name,
      :full_name => self.full_name,
      :email => self.email,
      :agencies => self.agencies.collect(&:acronym).join(','),
      :agency_ids => self.agencies.collect(&:id),
      :url => self.url,
      :salutation => self.salutation,
      :suffix => self.suffix,
      :work_phone => self.work_phone.try(:digits),
      :mobile_phone => self.mobile_phone.try(:digits),
      :alt_phone => self.alt_phone.try(:digits),
      :update_at => self.updated_at
    }
  end
end
