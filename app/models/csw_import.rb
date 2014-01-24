class CswImport < ActiveRecord::Base
  attr_accessible :title, :sync_frequency, :url, :metadata_field, :metadata_type, 
                  :use_agreement_id, :request_contact_info, :require_contact_info, 
                  :collection_ids
  
  belongs_to :setup
  has_many :catalogs
  
  # has_many :activity_logs, as: :loggable, order: "created_at DESC"
  has_many :activity_logs, through: :catalogs, order: 'activity_logs.created_at DESC', extend: ImportsExtension
  has_many :import_logs, class_name: 'ActivityLog', as: :loggable, order: 'created_at DESC' do
    def complete
      where(activity: 'CswImportComplete')
    end
    
    def start
      where(activity: 'CswImportStart')
    end
  end
  
  has_and_belongs_to_many :collections
  accepts_nested_attributes_for :collections  
    
  METADATA_TYPES = [
    #['display text','type']
    ['FGDC', 'FGDC']
  ]
  
  def fgdc_import_url(record)
    record.links.select{|l| l.type == self.metadata_field }.first.try(:url)
  end
  
  def default_attributes
    {
      csw_import_id: self.id,
      owner_setup_id: self.setup_id,
      use_agreement_id: self.use_agreement_id,
      request_contact_info: self.request_contact_info,
      require_contact_info: self.require_contact_info
    }
  end
    
  def async_import(force = false)
    self.update_attribute(:status, "Scheduled")
    
    Resque.enqueue(CswImportWorkerNg, self.id, force)
  end
  
  def import_from_record(record)
    uuid = record.identifier.gsub(/({|})/,"")
    puts uuid
    url = self.fgdc_import_url(record)
    
    catalog = setup.owned_catalogs.where(uuid: uuid, csw_import_id: self.id).first
    if catalog.nil?
      catalog = setup.owned_catalogs.build(
        self.default_attributes.merge({
          uuid: uuid,
          csw_import_id: self.id
        })
      )
    end
    catalog.setups << setup      
    catalog.remote_updated_at = record.modified.chomp.strip
    
    import_errors = catalog.import_from_fgdc(url)
    puts import_errors.inspect
    change_count = catalog.changes.keys.count
    
    if catalog.save and catalog.valid?
      puts 'Saved'
      catalog.activity_logs.create_import_log(message: "Import completed #{Time.zone.now}, #{change_count} field updated", changes: catalog.changes).save
      return true
    else
      puts 'Error during save'
      puts catalog.errors.full_messages.join("\n")

      catalog.activity_logs.create_import_error(message: "Error while try to validate record update: #{catalog.errors.full_messages.join(', ')}")

      # don't publish this record! it's invalid
      catalog.title ||= 'No title set'
      catalog.published_at = nil
      catalog.save(validate: false)
      return false
    end
  end
  
  def import!
    self.update_attribute(:status, "Fetching records")
    
    puts "Fetching client records"

    # client = RCSW::Client::Base.new(csw.url)
    # records = client.record(client.records.collect(&:identifier)).all
    total_records = self.records.count
    self.update_attribute(:status, "Importing 0 of #{total_records}")
    
    puts "Done fetching records #{total_records}"  
    
    counts= { success: 0, error: 0 }
    
    self.import_logs.create(activity: 'CswImportStart', log: { message: "Import Started" }) 
    
    self.records.each_with_index do |record, index|
      if self.import_from_record(record)
        counts[:success] += 1
      else
        counts[:error] += 1
      end
      
      if(index % 10 == 0)
        self.update_attribute(:status, "Importing #{index} of #{total_records}")
      end 
    end
    
    self.import_logs.create(activity: 'CswImportComplete', log: { message: "Import Complete", counts: counts })
  rescue => e
    puts "Exception! #{e}"    
  ensure
    puts "Completed import"
    self.update_attribute(:status, "Finished")
    Sunspot.commit    
  end
  
  def client
    @client ||= RCSW::Client::Base.new(self.url)
  end
  
  def records
    @records ||= client.record(client.records.collect(&:identifier)).all
  end
end
