class Asset < Catalog
  STATUSES = %w(Remote Local)

  delegate :downloadable, :to => :license

  scope :public, :joins => :license, :conditions => { :licenses => { :downloadable => true } }
  scope :restricted, :joins => :license, :conditions => { :licenses => { :downloadable => false } }

  validates_presence_of :title
  #validates_presence_of :license_id

  #after_create :setup_path
  
  after_create :create_repo!

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

  def has_extent?
    !self.geom.nil?
  end
  # 
  # def klass
  #   'Data'
  # end

  def for_gmapx
    return [] unless self.has_extent?
    self.geom.collect { |poly| GINA::JavaScript.new(self.goverlay_object(poly).to_javascript) }
  end
end
