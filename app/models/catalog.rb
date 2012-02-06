class Catalog < ActiveRecord::Base
  #The exception to the db name rule, since this is a collection of multiple types of items
  self.table_name = 'catalog'

  belongs_to :owner, :class_name => 'User'
  belongs_to :primary_contact, :class_name => 'Person'
  belongs_to :data_source

  belongs_to :source_agency, :class_name => 'Agency'
  belongs_to :funding_agency, :class_name => 'Agency'
  has_and_belongs_to_many :agencies, :join_table => 'catalog_agencies'
  has_and_belongs_to_many :geokeywords

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

  scope :published, lambda { where('published_at <= ?', Time.now.utc) }
  scope :unpublished, where('published_at is null')
  scope :archived, lambda { where('archived_at <= ?', Time.now.utc) }
  scope :not_archived, where('archived_at IS NULL')

  before_create :set_data_source
  before_create :repohex

  #Adding solr indexing
  searchable do
    text :title
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
      geokeywords.map(&:name)
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
    integer :agency_ids, :references => Agency, :multiple => true
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
      geokeywords.map(&:name)
    end
    #Geospatial
    location :locations, :multiple => true do
      locations.map { |location|
        next if location.center.nil?
        Sunspot::Util::Coordinates.new(location.center.try(:x), location.center.try(:y))
      }.compact!
    end
    string :title_sort do
      title.downcase.gsub(/^(an?|the)/, '')
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

  def repo
    @repo ||= RepoProxy.new(self, :class_name => 'RepoFile')
    @repo
  end
  
  def repo_exists?
    RepoProxy.exists?(self)
  end

  def repohex
    if read_attribute(:repohex).nil?
      hex = RepoProxy::generate_hex
      while File.directory? RepoProxy::repo_path(hex)
        hex = RepoProxy::generate_hex
      end
      write_attribute(:repohex, hex)
    end
    
    super
  end

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
    self.published_at <= Time.now.utc
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
        text = t.respond_to?(:text) ? t.text : t

        next if text.size < 3
        tag = Tag.find_or_create_by_text(text)
        self.tags << tag unless self.tags.include? tag
      end
    end
  end

  def tag_list
    self.tags.list
  end

  def short_description
    return nil if self.description.nil?
    #self.synopsis.text.gsub(/^(.{200}[\w.]*)(.*)/) {$2.empty? ? $1 : $1 + '...'}
    self.description.slice(0..200)
  end

  def as_json(opts = {})
    {
      :id => self.id,
      :type => self.type,
      :title => self.title,
      :description => self.short_description,
      :status => self.status,
      :source_agency_acronym => self.source_agency.try(:acronym),
      :source_agency_id => self.source_agency.try(:id),
=begin
      :start_date_year => self.start_date.try(:year),
      :end_date_year => self.end_date.try(:year),
      :geokeywords => self.geokeywords.collect(&:name),
      :agency_ids => self.agency_ids,
      :primary_contact_id => self.primary_contact_id,
      :person_ids => self.person_ids,
      :created_at => self.created_at,
      :updated_at => self.updated_at,
      :published_at => self.published_at,
=end
      :locations => self.locations
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
