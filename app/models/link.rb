class Link < ActiveRecord::Base
  CATEGORIES = [
    'Website', 'Download', 'Report', 'Shape File', 'WMS', 'WCS', 'WFS', 'KML',
    'Layer', 'Metadata', 'PDF', 'Map Service'
  ]

  belongs_to :entry, touch: true
  has_many :primary_organizations, through: :entry

  validates :display_text, length: { maximum: 255 }
  validates :url, length: { within: 11..255, message: 'is not a valid url' }
  validates :category, inclusion: { in: CATEGORIES, message: 'is not a valid category' }
  validates :uuid, uniqueness: true

  before_save :create_uuid

  include PublicActivity::Model

  tracked owner: proc { |controller, _model| controller.send(:current_user) },
          entry_id: :entry_id,
          parameters: :activity_params

  def activity_params
    { link: display_text }
  end

  def pdf?
    url.split('.').last.downcase == 'pdf'
  end

  # Pre:
  #   url is a valid pdf file location
  # Post:
  #   returns filename of the the localy cached file
  def cached_pdf(url)
    cache_dir = Rails.root.join('tmp/pdf_cache')
    FileUtils.mkdir_p(cache_dir)

    cache_filename = cache_dir.join(url.gsub('http://', '').gsub(/[\/%]/, '_'))

    if File.size?(cache_filename).nil?
      pbar = nil
      opts = {
        read_timeout: 1,
        content_length_proc: lambda do |t|
          if t && 0 < t
            pbar = ProgressBar.new(t)
            # pbar.file_transfer_mode
          end
        end,
        progress_proc: lambda do |s|
          pbar.increment! s if pbar
        end
      }
      # puts "Caching #{url}"
      open(cache_filename, 'wb') do |output|
        output << open(url, opts).read
      end
    end
    return cache_filename
  rescue => e
    FileUtils.rm(cache_filename)
    raise e
  end

  def pdf_to_text
    return '' unless self.pdf?

    pdf_text = ''
    begin
      pdf = PDF::Reader.new(cached_pdf(url))
      [20, pdf.page_count].min.times do |i|
        pdf_text << pdf.page(i + 1).text
      end
    rescue => e
      # don't die because of pdf or http error
      # puts url
      # puts 'Error: ' + e.message
      Rails.logger.info "Error: #{e.message}"
    end

    pdf_text
  end

  def to_s
    display_text
  end

  def create_uuid
    return unless uuid.nil?
    return if url.nil?

    self.uuid = UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, url).to_s
  end
end
