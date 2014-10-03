class Link < ActiveRecord::Base
  CATEGORIES = ['Website', 'Download', 'Report', 'Shape File', 'WMS', 'WCS', 'WFS', 'KML', 'Layer', 'Metadata', 'PDF', 'Map Service']

  belongs_to :asset, polymorphic: true

  validates_length_of :display_text, maximum: 255
  validates_length_of :url, in: 11..255, message: "%{value} is not a valid url"
  validates_inclusion_of :category, in: CATEGORIES, message: "%{value} is not a valid category"

  def is_pdf?
    self.url.split(".").last.downcase == "pdf"
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
        content_length_proc: lambda {|t|
          if t && 0 < t
            pbar = ProgressBar.new(t)
            #pbar.file_transfer_mode
          end
        },
        progress_proc: lambda {|s| pbar.increment! s if pbar }
      }
      puts "Caching #{url}"
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
    return "" unless self.is_pdf?

    pdf_text = ""
    begin
      pdf = PDF::Reader.new(cached_pdf(self.url))
      [20, pdf.page_count].min.times do |i|
        pdf_text << pdf.page(i+1).text
      end
    rescue => e
      # don't die because of pdf or http error
      puts self.url
      puts "Error: " + e.message
    end

    return pdf_text
  end
end
