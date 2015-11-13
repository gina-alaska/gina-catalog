class Cms::Page < ActiveRecord::Base
  SYSTEM_SLUGS = %w(home catalog page-not-found sitemap)

  include MustacheConcerns
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_closure_tree order: 'sort_order', name_column: :slug, dependent: :destroy

  belongs_to :portal
  belongs_to :cms_layout, class_name: 'Cms::Layout'
  has_many :cms_page_attachments, -> { order(position: :asc) }, class_name: 'Cms::PageAttachment'
  has_many :attachments, through: :cms_page_attachments, class_name: 'Cms::Attachment', source: :attachment

  scope :visible, -> { where(hidden: false) }
  scope :active, -> { where(draft: false) }

  validates :title, presence: true
  validates :slug, uniqueness: { scope: [:parent_id, :portal_id] }

  def to_s
    title
  end

  def depth_name
    (('&nbsp;' * (depth + 1) * 4) + title).html_safe
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
    context = render_context(portal, self)
    context[:data].content = basic_pipeline(context).call(content)[:output].to_s

    basic_pipeline(context).call(cms_layout.content)[:output].to_s.html_safe
  end

  def layout_pipeline(content, context)
    basic_pipeline(context).call(content)[:output].to_s.html_safe
  end

  def page_pipeline(content, context)
    basic_pipeline(context).call(content)[:output].to_s
  end

  def as_context
    context = super
    context['slug'] = url_path
    context
  end

  def mustache_route
    "page"
  end

  def mustache_url_params
    url_path
  end
end
