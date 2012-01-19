class Asset < Catalog
  STATUSES = %w(Remote Local)

  #belongs_to :data_source, :class_name => 'DataSource'

  #has_many :files, :class_name => 'AssetFile'
  #has_and_belongs_to_many :gcmd_themes
  #has_and_belongs_to_many :tags, :order => 'highlight ASC, text ASC' do
  #  def list
  #    proxy_owner.tags.collect(&:text).join(', ')
  #  end
  #end

  #has_many :locations, :as => :locatable, :dependent => :destroy
  
  #belongs_to :license

  #belongs_to :source_agency, :class_name => 'Agency'
  #belongs_to :funding_agency, :class_name => 'Agency'

  #belongs_to :owner, :class_name => 'User'
  #has_many :links, :as => :linkable
  #has_one :description, :class_name => 'AssetDescription'

  delegate :downloadable, :to => :license

  scope :public, :joins => :license, :conditions => { :licenses => { :downloadable => true } }
  scope :restricted, :joins => :license, :conditions => { :licenses => { :downloadable => false } }

  validates_presence_of :title
  #validates_presence_of :license_id

  #after_create :setup_path

  #define_index do
  #  indexes title,  :type => :string, :sortable => true
  #  indexes status, :sortable => true
  #
  #  indexes gcmd_themes(:name),  :as => :gcmd_themes, :sortable => true
  #  indexes gcmd_themes.path,  :as => :gcmd_theme_paths, :sortable => true
  #  indexes tags.text,         :as => :tags, :sortable => true
  #  indexes [source_agency(:name), source_agency.acronym], :as => :source_agency, :sortable => true
  #  indexes source_agency.acronym, :as => :source_agency_acronym, :sortable => true
  #  indexes [owner.first_name, owner.last_name], :as => :owner
  #  indexes [locations(:name), locations.region, locations.subregion], :as => :locations
  #  indexes description.text, :as => :description
  #
  #  has :title, :type => :string
  #  has :archived_at
  #  has "archived_at is not null", :as => :archived, :type => :boolean
  #  has license.downloadable,  :as => :downloadable
  #  has gcmd_themes(:id), :as => :gcmd_theme_ids
  #  has source_agency(:id), :as => :source_agency_id
  #  has funding_agency(:id), :as => :funding_agency_id
  #  has :start_date, :end_date, :created_at, :updated_at, :owner_id
  #  has "date_part('year', start_date)", :as => :start_date_year, :type => :integer
  #  has "date_part('year', end_date)", :as => :end_date_year, :type => :integer
  #
  #  set_property :delta => :delayed
  #end

  def archive
    self.archived_at = Time.now
    save
  end

  def unarchive
    self.archived_at = nil
    save
  end  

  def catalog_id
    id.to_s + '-Data'
  end

  def publish(current_user)
    return true if self.published?

    self.published_at = Time.now
    #self.published_by = current_user.id
    save
  end

  def unpublish
    return true unless self.published?

    self.published_at = nil
    #self.published_by = nil
    save
  end  

  def published?
    not self.published_at.nil? and self.published_at <= Time.now
  end

  def downloadable?
    published? and not self.files.empty?
  end

  def download_filename
    "#{self.id}_#{self.title.gsub(' - ', '-').gsub(' ', '_')}"
  end

  #def self.find_with_scope(args)
  #  args.each do |key,value|
  #    case key
  #      when :contains_text
  #      with_scope(:find => { :conditions => ['title ilike ? or description ilike ?', "%#{value}%"] }) do
  #        find(:all)
  #      end
  #    end
  #  end
  #end

  #def before_create
  #  if self.data_source.nil?
  #    self.data_source = DataSource.find_by_name('NSSI')
  #  end
  #end
  #
  #def setup_path
  #  digits = sprintf('%09d', self.id).match(/(\d{4})(\d{3})(\d{2})/).to_a
  #  digits.shift
  #  self.path = File.join(*digits)
  #  self.save!
  #end

  ##
  # Handle saving tags to this, this method will remove all current tags
  #
  # @param {Array} tags_string This is a space seperated list of tags
  ##
  #def tags=(tags)
  #  self.tags.clear unless self.new_record?
  #
  #  unless tags.nil? or tags.empty?
  #    tags.each do |t|
  #      next if t.size <= 3
  #      tag = Tag.find_or_create_by_text(t)
  #      self.tags << tag unless self.tags.include? tag
  #    end
  #  end
  #end
  #
  #def tag_list
  #  self.tags.list
  #end

  #def geometry
  #  return nil unless geom?
  #  self.as_wkt
  #end

  #def geometry=(geom_wkt)
  #  return if geom_wkt.nil? or geom_wkt.empty?
  #  return if self.as_wkt == geom_wkt
  #
  #  self.geom = GeometryCollection.new(4326)
  #  self.geom << Geometry.from_ewkt(geom_wkt)
  #end

  def has_extent?
    !self.geom.nil?
  end

  #def as_wkt
  #  self.geom.collect { |geom| geom.as_wkt }.join(',')
  #end

#  def locations
#    return [] if self.geom.nil?
#    self.locations.each do |location|
#      case location.geom.text_geometry_type
#        when 'POINT'
#          coords = geom.text_representation
#        when 'POLYGON'
#          coords = geom.text_representation.match(/\((.*)\)/)
#          coords = coords.nil? ? nil : coords[1]
#      end
#      { :type => geom.text_geometry_type, :coords => coords }
#    end
#  end
#
#  def locations=(locs)
#    gc = GeometryCollection.new(4326)
#
#    # We only care about the values of the hash if that is passed in
#    locs = locs.values if(locs.respond_to? :values)
#
#    locs.each do |loc|
#      next if loc['coords'].nil?
#
#      if(loc['type'] == 'POINT')
#        geometry = Point.from_coordinates(loc['coords'].split(' '))
#      else
#        coords = loc['coords'].split(',').collect { |l| l.split(' ') }
#        geometry = Polygon.from_coordinates([coords])
#      end
#      gc << geometry
#    end
#
#    self.geom = gc
#  end
#
  def klass
    'Data'
  end

  def for_gmapx
    return [] unless self.has_extent?
    self.geom.collect { |poly| GINA::JavaScript.new(self.goverlay_object(poly).to_javascript) }
  end

#  def as_json(opts = {})
#    {
#      :id => "#{self.id}-#{self.klass}",
#      :type => self.klass,
#      :title => self.title,
##      :tags => self.tags.list,
#      :start_date => self.start_date.try(:year),
#      :end_date => self.end_date.try(:year),
#      :status => self.status,
##      :source_agency_acronym => self.source_agency.try(:acronym),
#      :created_at => self.created_at,
#      :updated_at => self.updated_at,
##      :locations => self.locations
#    }
#  end
end
