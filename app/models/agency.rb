class Agency < ActiveRecord::Base
  CATEGORIES = [
    'Academic',
    'Industry/Consultants',
    'State',
    'Federal',
    'Local',
    'Foundation',
    'Non-Governmental',
    'Unknown'
  ]

  has_many :agency_people
  has_many :people, :through => :agency_people  
  has_and_belongs_to_many :setups, join_table: 'agencies_setups', uniq: true
  
  # has_many :catalog_agencies, :dependent => :destroy
  # has_many :projects, :through => :project_agencies
  has_and_belongs_to_many :catalogs, join_table: :catalog_agencies

  default_scope order('name ASC')
  scope :active, :conditions => { :active => true }, :order => 'name asc'
  
  validates_presence_of     :name
  validates_uniqueness_of   :name
  validates_length_of       :name, :maximum => 80
  
  validates_presence_of     :acronym
  validates_uniqueness_of   :acronym
  validates_length_of       :acronym, :maximum => 15
  
  validates_length_of       :description, :maximum => 255, :allow_nil => true
  validates_inclusion_of    :category, :in => CATEGORIES, :message => " please select one of following: #{Agency::CATEGORIES.join(', ')}"
  
  searchable do
    text :name
    string :name do
      name.downcase.gsub(/[\.,]/, '')
    end
    
    text :acronym
    string :acronym do
      acronym.downcase
    end
    
    
    text :description
    
    text :category
    string :category
    
    boolean :active
    
    integer :id
    integer :setup_ids, multiple: true do
      self.setups.pluck(:id)
    end
  end
  
  def name_with_acronym
    "#{name} (#{acronym})"
  end
  
  def category=(value)
    value = CATEGORIES[value] if value.is_a? Symbol
    super(value)
  end
  
  def to_s
    self.acronym
  end
end
