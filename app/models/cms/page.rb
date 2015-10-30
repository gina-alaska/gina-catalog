class Cms::Page < ActiveRecord::Base
  SYSTEM_SLUGS = %w(home catalog page-not-found)

  include MustacheConcerns
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_closure_tree order: 'sort_order', name_column: :slug, dependent: :destroy

  belongs_to :portal
  belongs_to :cms_layout, class_name: 'Cms::Layout'
  has_many :cms_page_attachments, -> { order(position: :asc) }, class_name: 'Cms::PageAttachment'
  has_many :attachments, through: :cms_page_attachments, class_name: 'Cms::Attachment', source: :attachment

  scope :visible, -> { where(hidden: false) }

  validates :title, presence: true
  validates :slug, uniqueness: { scope: [:parent_id, :portal_id] }

  def to_s
    title
  end

  def depth_name
    (('&nbsp;' * (depth+1) * 4) + title).html_safe
  end

  def system_page?
    !new_record? && SYSTEM_SLUGS.include?(ancestry_path.join('/'))
  end

  def parent_path
    ''
  end

  def should_generate_new_friendly_id?
    !slug?
  end

  def url_path
    ancestry_path.join('/')
  end

  def render
    layout_context = render_context(portal, self)
    layout_context[:mustache].content = page_pipeline(content, layout_context)
    layout_pipeline(cms_layout.content, layout_context)
  end

  def layout_pipeline(content, context)
    basic_pipeline(context).call(content)[:output].to_s.html_safe
  end

  def page_pipeline(content, context)
    basic_pipeline(context).call(content)[:output].to_s
  end

  def mustache_context(page = nil)
    attrs = attributes.dup

    attrs['url_path'] = url_path
    attrs['slug'] = url_path

    attrs
  end
end
