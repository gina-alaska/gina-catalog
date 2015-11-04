class Cms::Attachment < ActiveRecord::Base
  belongs_to :portal

  has_many :cms_page_attachments, class_name: 'Cms::PageAttachment'

  attachment :file

  validates :name, presence: true

  scope :images, -> { where(file_content_type: Refile.types[:image].content_type) }

  def image?
    Refile.types[:image].content_type.include? file_content_type
  end

  def mustache_context(page)
    image = dup
    image.readonly!

    context = OpenStruct.new(attributes)
    context.image = image
    context.title = name
    context.active = (page.attachments.images.first == self ? 'active' : '')
    # context.thumbnail = -> (size) { ::ActionView::Base.new.attachment_url(self, :file, :limit, *size.split('x')) }
    # context.fill = -> (size) { ::ActionView::Base.new.attachment_url(self, :file, :fill, *size.split('x'), 'Center') }
    # context.fit = -> (size) { ::ActionView::Base.new.attachment_url(self, :file, :fit, *size.split('x')) }
    # context.url = -> { ::ActionView::Base.new.attachment_url(self, :file) }
    context
  end
end
