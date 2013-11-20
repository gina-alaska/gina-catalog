class Link < ActiveRecord::Base
  CATEGORIES = ['Website', 'Download', 'Report', 'Shape File', 'WMS', 'WCS', 'WFS', 'KML', 'Layer', 'Metadata', 'PDF']

  belongs_to :asset, polymorphic: true

  validates_length_of :display_text, in: 3..255
  validates_length_of :url, in: 11..255, message: "%{value} is not a valid url"
  validates_inclusion_of :category, in: CATEGORIES, message: "%{value} is not a valid category"

  def is_pdf?
    self.url.split(".").last.downcase == "pdf"
  end

  def pdf_to_text
    return "" unless self.is_pdf?
    pdf_text = ""
    io = open(self.url)

    PDF::Reader.new(io).pages.each do |page|
      pdf_text << page.text
    end

    return pdf_text
  end
end
