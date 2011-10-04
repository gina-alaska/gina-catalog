class Agency < ActiveRecord::Base
  CATEGORIES = [
    'Academic',
    'Industry/Consultants',
    'State',
    'Federal',
    'Local',
    'Foundation',
    'Non-Governmental'
  ]

  has_many :agency_people
  has_many :people, :through => :agency_people  
  
  has_many :project_agencies, :dependent => :destroy
  has_many :projects, :through => :project_agencies
  
  scope :active, :conditions => { :active => true }, :order => 'name asc'
  
  validates_presence_of     :name
  validates_uniqueness_of   :name
  validates_length_of       :name, :maximum => 80
  
  validates_presence_of     :acronym
  validates_uniqueness_of   :acronym
  validates_length_of       :acronym, :maximum => 80
  
  validates_length_of       :description, :maximum => 255, :allow_nil => true
  validates_inclusion_of    :category, :in => CATEGORIES, :message => " please select one of follow: #{Agency::CATEGORIES.join(', ')}"
  
  def category=(value)
    value = CATEGORIES[value] if value.is_a? Symbol
    super(value)
  end
  
  def to_s
    self.acronym
  end
end
