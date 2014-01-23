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

  image_accessor :logo

  has_many :agency_people
  has_many :people, :through => :agency_people
  has_many :aliases, as: :aliasable, dependent: :destroy
   
  has_and_belongs_to_many :setups, join_table: 'agencies_setups', uniq: true
  belongs_to :images
  
  # has_many :catalog_agencies, :dependent => :destroy
  # has_many :projects, :through => :project_agencies
  has_and_belongs_to_many :catalogs, join_table: :catalog_agencies

  accepts_nested_attributes_for :aliases, reject_if: ->(a) { a[:text].blank? }, allow_destroy: true
  # default_scope order('name ASC')
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
    
    text :alias_names do
      self.aliases.pluck(:text).join(" ")
    end
    string :alias_names, multiple: true do
      self.aliases.pluck(:text)
    end
    
    text :description
    string :description
    
    text :category
    string :category
    
    boolean :active
    
    integer :id
    integer :setup_ids, multiple: true do
      self.setups.pluck(:id)
    end
  end
  
  def self.exists_by_name_or_alias?(name)
    search = Agency.search do
      any_of do
        with(:name, name)
        with(:alias_names, name)
      end
    end
    
    search.total > 0 
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
