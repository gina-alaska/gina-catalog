class Project < Catalog
  STATUSES = %w(Complete Ongoing Unknown Funded)

#  define_index do
#    indexes title, :type => :string, :sortable => true
#    indexes status, :sortable => true
#
#    indexes gcmd_themes(:name),  :as => :gcmd_themes, :sortable => true
#    indexes gcmd_themes(:path),  :as => :gcmd_theme_paths, :sortable => true
#    indexes synopsis.text, :as => :synopsis
#    indexes [agencies(:name), agencies.acronym], :as => :agencies
#    indexes [locations(:name), locations.region, locations.subregion], :as => :locations
#    indexes [primary_contact.first_name, primary_contact.last_name], :as => :primary_contact
#    indexes [people.first_name, people.last_name], :as => :contacts
#    indexes [owner.first_name, owner.last_name], :as => :owner, :sortable => true
#    indexes tags.text, :as => :tags
#    indexes [source_agency.name, source_agency.acronym], :as => :source_agency, :sortable => true
#    indexes source_agency.acronym, :as => :source_agency_acronym, :sortable => true
#    indexes note.text, :as => :note, :sortable => true
#
#    has :title, :type => :string
#    has :archived_at
#    has "archived_at is not null", :as => :archived, :type => :boolean
#    has :start_date, :end_date, :created_at, :updated_at, :published_at, :owner_id
#    has "date_part('year', start_date)", :as => :start_date_year, :type => :integer
#    has "date_part('year', end_date)", :as => :end_date_year, :type => :integer
#
#    has gcmd_themes(:id), :as => :gcmd_theme_ids
#    has source_agency(:id), :as => :source_agency_id
#    has funding_agency(:id), :as => :funding_agency_id
#    has agencies(:id), :as => :agency_ids
#    has "(published_at IS NOT NULL)", :as => 'published', :type => :boolean
#    set_property :delta => :delayed
#  end
  
  #validates_presence_of :title
  #validates_presence_of :owner
  #validates_length_of :title, :maximum => 255
  #validates_inclusion_of :status, :in => STATUSES

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
end
