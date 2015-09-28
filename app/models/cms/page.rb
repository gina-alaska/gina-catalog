class Cms::Page < ActiveRecord::Base
  SYSTEM_SLUGS = %w(home catalog page-not-found)

  include MustacheConcerns
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_closure_tree order: 'sort_order', name_column: :slug, dependent: :destroy

  belongs_to :portal
  belongs_to :cms_layout, class_name: 'Cms::Layout'

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
    if !slug?
      true
    else
      false
    end
  end

  def render(use_layout = true)
    if use_layout && cms_layout
      layout_context = render_context(portal)
      layout_context[:mustache].content = page_pipeline(content, render_context(portal))
      layout_pipeline(cms_layout.content, layout_context)
    else
      layout_pipeline(content, render_context(portal))
    end
  end

  def layout_pipeline(content, context)
    markdown_pipeline(context).call(content)[:output].to_s.html_safe
  end

  def page_pipeline(content, context)
    basic_pipeline(context).call(content)[:output].to_s
  end
end
