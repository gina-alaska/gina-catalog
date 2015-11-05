class Cms::Attachment < ActiveRecord::Base
  include MustacheConcerns

  belongs_to :portal

  has_many :cms_page_attachments, class_name: 'Cms::PageAttachment'

  attachment :file

  validates :name, presence: true

  scope :images, -> { where(file_content_type: Refile.types[:image].content_type) }

  def image?
    Refile.types[:image].content_type.include? file_content_type
  end

  def mustache_context(page)
    context = super(page)
    context['title'] = name
    context['active'] = (page.attachments.images.first == self ? 'active' : '')
    context
  end

  def mustache_url
    Refile.attachment_url(self, :file)
  end
end
