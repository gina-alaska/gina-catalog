class Project < ActiveRecord::Base
  STATUSES = %w(Complete Ongoing Unknown Funded)
  
  has_one :synopsis, :dependent => :destroy
  belongs_to :user
  
  has_many :project_agencies, :dependent => :destroy
  has_many :agencies, :through => :project_agencies

  belongs_to :source_agency, :class_name => 'Agency'
  belongs_to :funding_agency, :class_name => 'Agency'

  has_many :project_themes, :dependent => :destroy
  has_many :themes, :through => :project_themes

  has_and_belongs_to_many :gcmd_themes

  has_and_belongs_to_many :tags, :order => 'highlight ASC, text ASC' do
    def list
      proxy_owner.tags.collect(&:text).join(', ')
    end
  end
  
  has_many :project_contacts, :dependent => :destroy

  has_many :people, :through => :project_contacts do
    def primary_contacts
      proxy_owner.people.find(:all, :conditions => { :project_contacts => { :primary => true } })
    end
    def primary_contact
      proxy_owner.people.find(:first, :conditions => { :project_contacts => { :primary => true } })
    end
  end

  has_one :note, :as => :noted, :dependent => :destroy
  has_many :links, :as => :linkable, :dependent => :destroy
  has_many :locations, :as => :locatable, :dependent => :destroy

  # Updated to a new belongs_to relation for the primary contact
  #delegate :primary_contacts, :to => :people
  #delegate :primary_contact, :to => :people
  
  belongs_to :primary_contact, :class_name => 'Person' 

  has_many :project_geolocations, :dependent => :destroy
  has_many :geolocations, :through => :project_geolocations
  
  belongs_to :data_source
  
  belongs_to :owner, :class_name => 'User'

  define_index do
    indexes title, :type => :string, :sortable => true
    indexes status, :sortable => true
    
    indexes gcmd_themes(:name),  :as => :gcmd_themes, :sortable => true
    indexes gcmd_themes(:path),  :as => :gcmd_theme_paths, :sortable => true
    indexes synopsis.text, :as => :synopsis
    indexes [agencies(:name), agencies.acronym], :as => :agencies
    indexes [locations(:name), locations.region, locations.subregion], :as => :locations
    indexes [primary_contact.first_name, primary_contact.last_name], :as => :primary_contact
    indexes [people.first_name, people.last_name], :as => :contacts
    indexes [owner.first_name, owner.last_name], :as => :owner, :sortable => true
    indexes tags.text, :as => :tags
    indexes [source_agency.name, source_agency.acronym], :as => :source_agency, :sortable => true
    indexes source_agency.acronym, :as => :source_agency_acronym, :sortable => true
    indexes note.text, :as => :note, :sortable => true

    has :title, :type => :string
    has :archived_at
    has "archived_at is not null", :as => :archived, :type => :boolean
    has :start_date, :end_date, :created_at, :updated_at, :published_at, :owner_id
    has "date_part('year', start_date)", :as => :start_date_year, :type => :integer
    has "date_part('year', end_date)", :as => :end_date_year, :type => :integer

    has gcmd_themes(:id), :as => :gcmd_theme_ids
    has source_agency(:id), :as => :source_agency_id
    has funding_agency(:id), :as => :funding_agency_id
    has agencies(:id), :as => :agency_ids
    has "(published_at IS NOT NULL)", :as => 'published', :type => :boolean
    set_property :delta => :delayed
  end
  
  sphinx_scope(:sort_by) do |field, mode|
    {:order => field, :sort_mode => mode}
  end
  
  validates_presence_of :title
  #validates_presence_of :owner
  validates_length_of :title, :maximum => 255
  validates_inclusion_of :status, :in => STATUSES
  
  scope :published, lambda { |current_user| {
    :conditions => ['published_at <= ? or owner_id = ?', Time.now.utc, current_user.id] 
  } }

  scope :unpublished, :conditions => 'published_at is null'

  def archive
    self.archived_at = Time.now
    save
  end

  def unarchive
    self.archived_at = nil
    save
  end

  def catalog_id
    id.to_s + '-Project'
  end

  def before_create
    self.data_source = DataSource.find_by_name('NSSI') if self.data_source.nil?
  end
  
#  def after_create
#    unless @primary_contact.nil?
#      pc = self.project_contacts.find_by_person_id(@primary_contact.id)
#      #pc.primary = true
#      pc.save!
#    end
#  end
  
  def publish(current_user)
    return true if self.published?
    
    self.published_at = Time.now
    self.published_by = current_user.id
    save
  end

  def unpublish
    return true unless self.published?
    
    self.published_at = nil
    self.published_by = nil
    save
  end
  
  def published?
    !self.published_at.nil? and self.published_at <= Time.now.utc
  end
  
  ##
  # Handle saving tags to this, this method will remove all current tags
  #
  # @param {String} tags_string This is a space seperated list of tags
  ##
  def tags=(tags)
    self.tags.clear unless self.new_record?
    
    unless tags.nil? or tags.empty?
      tags.each do |t|
        next if t.size < 3
        tag = Tag.find_or_create_by_text(t)
        self.tags << tag unless self.tags.include? tag
      end
    end    
  end

  def tag_list
    self.tags.list
  end

  # Project_contacts validations will make sure that a person is only added once to a project
  def old_primary_contact=(contact)
    self.people << contact unless self.people.include? contact
    
    if self.new_record?
      @primary_contact = contact
    else
      return contact if self.primary_contact == contact
      
      # Remove the old primary contact
      if self.primary_contact
        pc = self.project_contacts.find_by_person_id(self.primary_contact.id)
        pc.primary = false
        pc.save!
      end
      
      # Add the new primary contact
      pc = self.project_contacts.find_by_person_id(contact.id)
      pc.primary = true
      pc.save!
    
      people.reload
      project_contacts.reload
    end
    
    contact
  end
  
  def truncated_synopsis
    return nil if self.synopsis.nil? or self.synopsis.text.nil?
    #self.synopsis.text.gsub(/^(.{200}[\w.]*)(.*)/) {$2.empty? ? $1 : $1 + '...'}
    self.synopsis.text.slice(0..200)
  end
  
  def agency_acronym_list
    self.agencies.collect { |a| a.acronym }.join(', ')
  end
  
  def build_source_url
    return false unless self.source_url.nil?
    return false if self.data_source.nil? or self.data_source.url_template.nil?
    
    erb = ERB.new(self.data_source.url_template)
    self.source_url = erb.result binding
  end

  def to_xml(options = {})
    default_except = [
            :budget, :delta, :remote_url, :status, :funding_year,
            :primary_contact_id, :location_id, :remote_source_id, :phase_id, :owner_id, :parent_id, :program_id, :report_id, :status_id,
            :user_id, :agency_id, :abstract_id, :data_source_id, :source_agency_id, :published_at, :published_by]
    options[:except] = (options[:except] ? options[:except] + default_except : default_except)

    default_methods = [:tag_list]
    options[:methods] = (options[:methods] ? options[:methods] + default_methods : default_methods)

    options[:include] = {
      :tags => { :only => [:text] },
      :primary_contact => { :except => [:id] },
      :synopsis => {},
      :data_source => { :except => [:url_template] },
      :agencies => {},
      :locations => { :except => [:id] },
      :themes => { :only => [:name] }
    }
    
    #options[:include] = (options[:include] ? options[:include] + default_include : default_include)
    super(options)
  end

  def klass
    'Project'
  end
  
  def self.filter(f, &block)
    if f.length > 0
      key, value = f.shift
      case
        when key == 'contact'
          with_scope(:find => {
            :include => :project_contacts,
            :conditions => ["project_contacts.person_id = ?", value]
          }) { filter(f, &block) }
        when key == 'contains_text'
          with_scope(:find => { 
            :include => [:synopsis, :tags, :locations],
            :conditions => ["title ILIKE ? or locations.name ILIKE ? or synopses.text ILIKE ? or tags.text ILIKE ?", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%"]
          }) { filter(f, &block) }
        when key == 'starts_after'
          with_scope(:find => {
            :conditions => ["start_date > ?", Time.parse(value)]
          }) { filter(f, &block) }
        when key == 'ends_before'
          with_scope(:find => {
            :conditions => ["end_date < ?", Time.parse(value)]
          }) { filter(f, &block) }
        when key == 'data_source'
          with_scope(:find => {
            :conditions => { :data_source_id => value }
          }) { filter(f, &block) }
        when key == 'status'
          with_scope(:find => {
            :conditions => { :status => value }
          }) { filter(f, &block) }
        when key == 'agency'
          with_scope(:find => {
            :include => :project_agencies,
            :conditions => ["project_agencies.agency_id = ?", value]
          }) { self.filter(f, &block) }
      end
    else
      yield
    end
  end
  
  def self.find_all_by_filter(f, *opts)
    filter(f.dup) {
      find(:all, *opts)
    }
  end
  
  def self.count_by_filter(f, *opts)
    filter(f.dup) {
      count(*opts)
    }
  end

  def as_json(opts = {})
    {
      :id => "#{self.id}-#{self.klass}",
      :type => self.klass,
      :title => self.title,
#      :tags => self.tags.list,
      :description => self.truncated_synopsis,
      :start_date_year => self.start_date.try(:year),
      :end_date_year => self.end_date.try(:year),
      :status => self.status,
      :source_agency_acronym => self.source_agency.try(:acronym),
      :created_at => self.created_at,
      :updated_at => self.updated_at,
      :published_at => self.published_at,
      :locations => self.locations
    }
  end
end
