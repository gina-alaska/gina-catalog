class Catalog < ActiveRecord::Base
  include CatalogConcerns::FgdcImport
  include CatalogConcerns::Upload
  
  STATUSES = %w(Complete Ongoing Unknown Funded)

  attr_accessible :links_attributes, :locations_attributes, :download_urls_attributes, :uploads_attributes,
    :collection_ids, :title, :description, :start_date, :end_date, :status, :owner_id, 
    :primary_contact_id, :contact_ids, :source_agency_id, :funding_agency_id, :data_type_ids, 
    :iso_topic_ids, :agency_ids, :tags, :geokeyword_ids, :type, :use_agreement_id, :request_contact_info, 
    :require_contact_info, :remote_updated_at, :source_url, :owner_setup_id, :csw_import_id, :uuid
  
  #The exception to the db name rule, since this is a collection of multiple types of items
  self.table_name = 'catalog'
  self.inheritance_column = :_type_disabled

  # delegate :downloadable, :to => :license

  scope :active, :conditions => ['catalog.archived_at is null']
  scope :public, :joins => :license, :conditions => { :licenses => { :downloadable => true } }
  scope :restricted, :joins => :license, :conditions => { :licenses => { :downloadable => false } }

  validates_presence_of :title
  validates :title, length: { maximum: 255 }
  validates_presence_of :type
  validates_presence_of :description
  validate :temporal_continuity
  validates :uuid, uniqueness: true
  validates_associated :uploads
  # validates_presence_of :owner_id
  
  #validates_presence_of :license_id

  #after_create :setup_path
  
  # after_create :create_repo!

  belongs_to :owner, :class_name => 'User'
  belongs_to :primary_contact, :class_name => 'Person'
  belongs_to :data_source
  belongs_to :owner_setup, :class_name => 'Setup'
  belongs_to :csw_import
  
  has_many :activity_logs, as: :loggable, order: "created_at DESC", dependent: :destroy, extend: ImportsExtension do
    def updates
      where(activity: %w{ Update Create Import })
    end
  end
  has_many :uploads, dependent: :destroy
  
  has_many :contact_infos, :dependent => :destroy
  has_many :downloads, class_name: 'ActivityLog'
  
  has_many :catalogs_setups, uniq: true
  has_many :setups, :through => :catalogs_setups, uniq: true
  #has_and_belongs_to_many :setups, uniq: true
  
  has_many :catalogs_collections, uniq: true
  has_many :collections, :through => :catalogs_collections, uniq: true do
    def list
      #proxy_association.owner.collections.names.join(', ')
      names.join(', ')
    end
    
    def names
      order('name ASC').pluck(:name)
    end
  end
  
#  has_and_belongs_to_many :catalog_collections, uniq: true do
#    def list
#      proxy_association.owner.catalog_collections.collection.join(', ')
#    end
#    def collection
#      proxy_association.owner.catalog_collections.pluck(:name)
#    end
#  end
  
  has_many :download_urls
  has_one :repo
  belongs_to :use_agreement
  
  belongs_to :source_agency, :class_name => 'Agency'
  belongs_to :funding_agency, :class_name => 'Agency'
  has_and_belongs_to_many :agencies, :join_table => 'catalog_agencies', uniq: true
  #has_and_belongs_to_many :people, :join_table => 'catalogs_contacts'
  has_and_belongs_to_many :geokeywords, :order => 'name ASC' do
    def list
      proxy_association.owner.geokeywords.collection.join(', ')
    end
    def collection
      proxy_association.owner.geokeywords.pluck(:name).compact
    end
  end
  has_and_belongs_to_many :iso_topics do 
    def list
      proxy_association.owner.iso_topics.collection.join(', ')
    end
    def collection
      proxy_association.owner.iso_topics.pluck(:name).compact
    end
  end
  has_and_belongs_to_many :data_types

  has_and_belongs_to_many :tags, :join_table => 'catalog_tags', :order => 'highlight ASC, text ASC' do
    def list
      proxy_association.owner.tags.collection.join(', ')
    end

    def collection
      proxy_association.owner.tags.pluck(:text).compact
    end
  end

  has_and_belongs_to_many :people, :join_table => 'catalog_people'

  has_many :catalogs_contacts, uniq: true, dependent: :destroy
  has_many :contacts, class_name: 'Person', through: :catalogs_contacts, uniq: true

  has_many :links, :as => :asset, :dependent => :destroy
  has_many :locations, foreign_key: 'asset_id', :dependent => :destroy
  has_many :map_layers, :dependent => :destroy

  scope :published, lambda { where('published_at <= ?', Time.now.utc) }
  scope :unpublished, where('published_at is null')
  scope :archived, lambda { where('archived_at <= ?', Time.now.utc) }
  scope :not_archived, where('archived_at IS NULL')

  before_validation :create_uuid
  # before_create :repohex
  
  accepts_nested_attributes_for :download_urls, reject_if:  proc { |download| download['url'].blank? and download['name'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :links, reject_if:  proc { |link| link['url'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :locations, reject_if:  proc { |location| location['name'].blank? and location['wkt'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :map_layers, reject_if:  proc { |layer| layer['url'].blank? and layer['name'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :uploads, reject_if:  proc { |upload| upload['file'].blank? and upload['exists'] != 'true' }, allow_destroy: true
  
  def to_liquid
    { 
      'title' => self.title,
      'description' => self.description,
      'type' => self.type,
      'url' => "/catalogs/#{self.to_param}",
      'start_date' => self.start_date,
      'end_date' => self.end_date,
      'downloads' => self.downloads.count,
      'previews' => self.uploads.previews

    }
  end

  #Adding solr indexing
  searchable do
    text :title, { :boost => 2.0, :stored => true }
    text :description
    text :type, { :boost => 2.0, :stored => true } do
      type == 'Asset' ? 'Data' : type
    end
    text :tags do
      tags.map(&:text)
    end
    text :agency do
      agencies.map{|a| [a.name, a.acronym]}
    end
    text :source_agency do
      [source_agency.name, source_agency.acronym] unless source_agency.nil?
    end
    text :funding_agency do
      [funding_agency.name, funding_agency.acronym] unless funding_agency.nil?
    end
    text :locations do
      locations.map(&:name)
    end
    text :geokeywords do
      geokeywords.map(&:name).sort
    end
    text :iso_topics do
      iso_topics.map(&:name)
    end
    text :collections do
      collections.names
    end
    text :iso_topics_long do
      iso_topics.map(&:long_name)
    end
    text :data_types do
      data_types.map(&:name)
    end
    text :primary_contact do
      [primary_contact.first_name, primary_contact.last_name, primary_contact.email] unless primary_contact.nil?
    end
    text :contacts do
      contacts.map{|a| [a.first_name, a.last_name, a.email]}
    end
        
    string :agency_types, :multiple => true do
      types = [source_agency.try(:category), funding_agency.try(:category)]
      types += agencies.collect(&:category)
      types.uniq.compact
    end
    
    text :source_url do 
      source_url.try(:gsub, 'http://', '').try(:split, '/')
    end

    # text :links do
    #   all_text = ""
    #   self.links.where("url ilike ?", "%.pdf").each do |link|
    #     all_text << link.pdf_to_text
    #   end
    #   all_text
    # end
    # 
    string :data_types, :multiple => true do
      data_types.map(&:name)
    end
    
    string :status
    string :record_type do
      type
    end
    string :uuid
    
    integer :owner_setup_id
    integer :use_agreement_id
    integer :setup_ids, :multiple => true
    integer :id
    integer :owner_id
    integer :primary_contact_id
    integer :license_id
    integer :data_source_id
    integer :source_agency_id
    integer :funding_agency_id
    integer :contact_ids, :references => Person, :multiple => true
    integer :agency_ids, :references => Agency, :multiple => true
    integer :iso_topic_ids, :multiple => true
    integer :collection_ids, :multiple => true
    integer :data_type_ids, :multiple => true
    
    boolean :long_term_monitoring
    boolean :sds do
      self.use_agreement_id? or self.request_contact_info? or self.require_contact_info?
    end
    
    boolean :active do
      archived_at.nil?
    end

    integer :archived_at_year do
      archived_at.try(:year)
    end
    integer :published_at_year do
      published_at.try(:year)
    end
    integer :start_date_year do
      start_date.try(:year)
    end
    integer :end_date_year do
      end_date.try(:year)
    end
    integer :created_at_year do
      created_at.try(:year)
    end
    integer :updated_at_year do
      updated_at.try(:year)
    end
    string :geokeywords_name, :multiple => true do
      geokeywords.map(&:name).sort
    end
    
    time :published_at
    time :updated_at
    time :created_at
    
    #Geospatial
    location :locations, :multiple => true do
      locations.map { |location|
        next if location.center.nil?
        Sunspot::Util::Coordinates.new(location.center.try(:x), location.center.try(:y))
      }.compact!
    end
    string :geokeyword_sort do
      geokeywords.map(&:name).sort.join(' ')
    end
    
    #Sorts
    string :title_sort do
      filtered_words = ['a', 'the', 'and', 'an', 'of', 'i', '' ]
      title.downcase.split(/\s+/).delete_if { |word| filtered_words.include? word }.join(' ').gsub(/["',]/,'')
    end

    string :agency_sort do
      source_agency.try(&:name)
    end
    
    string :source_agency_acronym_sort do
      source_agency.try(&:acronym)
    end

    string :created_at_sort do
      created_at
    end

    string :updated_at_sort do
      updated_at
    end

    string :type_sort do
      type
    end

    string :status_sort do
      status
    end
  end
  
  def self.geokeyword_intersects(wkt, srid=4326)
    wkt = wkt.as_text if wkt.respond_to? :as_text
    joins(:geokeywords).where("ST_Intersects(geom, ?::geometry)", "SRID=#{srid};#{wkt}")
  end
  
  def self.location_intersects(wkt, srid=4326)
    wkt = wkt.as_text if wkt.respond_to? :as_text
    joins(:locations).where("ST_Intersects(geom, ?::geometry)", "SRID=#{srid};#{wkt}")
  end
  
  def download_count
    self.activity_logs.downloads.count
  end
  
  def create_uuid
    self.uuid ||= UUIDTools::UUID.timestamp_create
  end
  
  def sds?
    self.remote_download? or !self.use_agreement.nil? or self.request_contact_info? or self.require_contact_info?
  end
  
  def remote_download?
    !self.download_urls.empty?
  end
  
  def local_download?
    self.archive_exists?
  end
  
  def downloadable?
    self.remote_download? or self.local_download?
  end

  # def repohex
  #   if read_attribute(:repohex).nil?
  #     hex = RepoProxy::generate_hex
  #     while File.directory? RepoProxy::repo_path(hex)
  #       hex = RepoProxy::generate_hex
  #     end
  #     write_attribute(:repohex, hex)
  #   end
  #   
  #   super
  # end

  def readme_template
    <<-EOF
Title: #{self.title}
    EOF
  end

  def available_in?(setup)
    self.owner_setup == setup or self.setups.include?(setup) or self.owner_setup.ancestors.include?(setup)
  end

  def archive
    self.archived_at = Time.zone.now
    save!
  end

  def unarchive
    self.archived_at = nil
    save!
  end

  def catalog_id
    "#{self.id}-#{self.type}"
  end

  def publish(current_user = nil)
    return true if self.published?

    self.published_at = Time.zone.now
    # self.published_by = current_user.id
    save
  end

  def unpublish
    return true unless self.published?

    self.published_at = nil
    # self.published_by = nil
    save
  end

  def published?
    !self.published_at.nil? && self.published_at <= Time.now.utc
  end

  ##
  # Handle saving tags to this, this method will remove all current tags
  #
  # @param {String} tags_string This is a space seperated list of tags
  ##
  def tags=(tags)
    # self.tags.clear unless self.new_record?
    if tags.kind_of? String
      tags = tags.split(/,\s*/).uniq.compact
    end
    
    ids = []
    unless tags.nil?
      tags.each do |t|
        text = t.respond_to?(:text) ? t.text : t

        next if text.size < 3
        ids << Tag.match_or_create(text).id
      end
    end    
    self.tag_ids = ids
  end
  
  def geokeywords=(keywords) 
    # self.geokeywords.clear unless self.new_record?
    if keywords.kind_of? String
      keywords = keywords.split(/,\s*/).uniq.compact
    end
    
    ids = []
    unless keywords.nil? or keywords.empty?
      keywords.each do |t|
        text = t.respond_to?(:text) ? t.text : t
        
        next if text.size < 3
        ids << Geokeyword.where(name: text).first.id
        
      end
      self.geokeyword_ids = ids
    end
  end

  def tag_list
    self.tags.list
  end

  def short_description
    self.description.try(:split, "\n").try(:first).try(:truncate, 150)
  end

  def as_json(opts = {})
    if opts and opts[:format] == 'basic'
      basic_json
    else
      full_json
    end
  end
  
  def basic_json
    {
      :id => self.id,
      :type => self.type,
      :title => self.title,
      :description => self.short_description,
      :status => self.status,
      :downloadable => self.downloadable?,
      :source_agency_acronym => self.source_agency.try(:acronym),
      :source_agency_id => self.source_agency.try(:id),
      :geokeywords => self.geokeywords.list,
      :created_at => self.created_at,
      :updated_at => self.updated_at,
      :published_at => self.published_at,
      :locations => self.locations
    }    
  end
  
  def full_json
    {
      :id => self.id,
      :type => self.type,
      :title => self.title,
      :description => self.description,
      :status => self.status,
      :tags => self.tags.join(', '),
      :links => self.links,
      :source_agency_acronym => self.source_agency.try(:acronym),
      :source_agency_id => self.source_agency_id,
      :funding_agency_id => self.funding_agency_id,
      :start_date => self.start_date.try(:strftime, '%F'),
      :end_date => self.end_date.try(:strftime, '%F'),
      :geokeywords => self.geokeywords.list,
      :geokeyword_ids => self.geokeyword_ids,
      :agency_ids => self.agency_ids,
      :primary_contact_id => self.primary_contact_id,
      :person_ids => self.person_ids,
      :iso_topic_ids => self.iso_topic_ids,
      :published_at => self.published_at,
      :created_at => self.created_at,
      :updated_at => self.updated_at,
      :locations => self.locations,
      :repo_slug => self.repo.try(:slug),
      :long_term_monitoring => self.long_term_monitoring,
      :owner_id => self.owner_id,
      :data_type_ids => self.data_type_ids
    }    
  end
  
  def to_param
  	"#{self.id}-#{self.title.try(:truncate, 50).try(:parameterize)}"
  end

  def to_s
    self.title
  end

  def geometry_collection
    locs = self.locations.collect(&:wkt).compact
    
    if locs.count > 0
      "GEOMETRYCOLLECTION(#{locs.join(',')})"
    else
      ''
    end
  end
  
  def geometry_center_collection
    locs = self.locations.collect { |l| l.center.try(:as_text) }.compact
    
    if locs.count > 0
      "GEOMETRYCOLLECTION(#{locs.join(',')})"
    else
      ''
    end
  end
  
  def self.assign_owner_setups
    Catalog.includes(:setups).where(owner_setup_id:nil).each do |c|
      if c.owner_setup.nil?
        c.owner_setup = c.setups.first
        c.save
      end
    end
  end

  def self.top_downloads(setup)

  end

  protected

  def build_source_url
    return false unless self.source_url.nil?
    return false if self.data_source.nil? or self.data_source.url_template.nil?

    erb = ERB.new(self.data_source.url_template)
    self.source_url = erb.result binding
  end

  def set_data_source
    self.data_source = DataSource.find_by_name('NSSI') if self.data_source.nil?
  end

  def temporal_continuity
    unless self.start_date.nil? or self.end_date.nil?
      errors.add(:base, "Start date must come before the end date.") if self.start_date > self.end_date
    end
  end
end
