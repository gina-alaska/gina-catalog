class Project < Catalog
  STATUSES = %w(Complete Ongoing Unknown Funded)
  
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
