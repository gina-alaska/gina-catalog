class Catalog < ActiveRecord::Base
  #The exception to the db name rule, since this is a collection of multiple types of items
  self.table_name = 'catalog'

  belongs_to :owner, :class_name => 'User'
  belongs_to :primary_contact, :class_name => 'Person'
  belongs_to :data_source
  
  has_many :download_urls
  has_one :repo
  belongs_to :use_agreement
  
  belongs_to :source_agency, :class_name => 'Agency'
  belongs_to :funding_agency, :class_name => 'Agency'
  has_and_belongs_to_many :agencies, :join_table => 'catalog_agencies'
  has_and_belongs_to_many :geokeywords, :order => 'name ASC' do
    def list
      proxy_association.owner.geokeywords.collection.join(', ')
    end
    def collection
      proxy_association.owner.geokeywords.collect(&:name).compact
    end
  end
  has_and_belongs_to_many :iso_topics
  has_and_belongs_to_many :data_types

  has_and_belongs_to_many :tags, :join_table => 'catalog_tags', :order => 'highlight ASC, text ASC' do
    def list
      proxy_association.owner.tags.collection.join(', ')
    end

    def collection
      proxy_association.owner.tags.collect(&:text).compact
    end
  end

  has_and_belongs_to_many :people, :join_table => 'catalog_people'

  has_many :links, :as => :asset, :dependent => :destroy
  has_many :locations, :as => :asset, :dependent => :destroy
  has_many :contact_infos, :dependent => :destroy

  scope :published, lambda { where('published_at <= ?', Time.now.utc) }
  scope :unpublished, where('published_at is null')
  scope :archived, lambda { where('archived_at <= ?', Time.now.utc) }
  scope :not_archived, where('archived_at IS NULL')

  before_create :set_data_source
  # before_create :repohex
  
  accepts_nested_attributes_for :links, :locations, :download_urls

  #Adding solr indexing
  searchable do
    text :title, { :boost => 2.0, :stored => true }
    text :description
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
    text :geokeywords do
      geokeywords.map(&:name).sort
    end
    text :iso_topics do
      iso_topics.map(&:name)
    end
    text :iso_topics_long do
      iso_topics.map(&:long_name)
    end
    text :data_types do
      data_types.map(&:name)
    end
    
    text :source_url do 
      source_url.try(:gsub, 'http://', '').try(:split, '/')
    end
    
    string :data_types, :multiple => true do
      data_types.map(&:name)
    end
    
    string :status
    string :type
    string :uuid
    integer :id
    integer :owner_id
    integer :primary_contact_id
    integer :license_id
    integer :data_source_id
    integer :source_agency_id
    integer :funding_agency_id
    integer :person_ids, :references => Person, :multiple => true
    integer :agency_ids, :references => Agency, :multiple => true
    integer :iso_topic_ids, :multiple => true
    integer :data_type_ids, :multiple => true
    
    boolean :long_term_monitoring
    
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
    string :title_sort do
      filtered_words = ['a', 'the', 'and', 'an', 'of', 'i', '' ]
      title.downcase.split(/\s+/).delete_if { |word| filtered_words.include? word }.join(' ').gsub(/["',]/,'')
    end
    string :source_agency_acronym do
      source_agency.try(&:acronym)
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
  
  def convert_repo!
    if self.repo.nil? && self.repohex
      self.create_repo!(repohex: self.repohex, slug: self.repohex)
    end
  end
  
  def downloadable?(format = :zip)
    self.repo && !self.repo.empty? && self.repo.archive_available?(format)
  end
  
  def repo_exists?
    RepoProxy.exists?(self)
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

  def archive
    self.archived_at = Time.now
    save!
  end

  def unarchive
    self.archived_at = nil
    save!
  end

  def catalog_id
    "#{self.id}-#{self.type}"
  end

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
    !self.published_at.nil? && self.published_at <= Time.now.utc
  end

  ##
  # Handle saving tags to this, this method will remove all current tags
  #
  # @param {String} tags_string This is a space seperated list of tags
  ##
  def tags=(tags)
    # self.tags.clear unless self.new_record?

    unless tags.nil? or tags.empty?
      tags.each do |t|
        text = t.respond_to?(:text) ? t.text : t

        next if text.size < 3
        tag = Tag.find_or_create_by_text(text)
        self.tags << tag unless self.tags.include? tag
      end
    end
  end
  
  def geokeywords=(keywords) 
    # self.geokeywords.clear unless self.new_record?
    
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
    return nil if self.description.nil?
    #self.synopsis.text.gsub(/^(.{200}[\w.]*)(.*)/) {$2.empty? ? $1 : $1 + '...'}
    self.description.slice(0..150)
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
end
