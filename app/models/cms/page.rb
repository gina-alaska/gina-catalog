class Cms::Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :portal
  belongs_to :cms_layout, class_name: 'Cms::Layout'

  def parent_path
    ''
  end

  def slug_candidates
    [
      [:parent_path, :title]
    ]
  end

  def should_generate_new_friendly_id?
    if !slug? || title_changed?
      true
    else
      false
    end
  end

  def render
    layout_context = render_context
    layout_context[:mustache].content = page_pipeline(content, render_context)
    layout_pipeline(cms_layout.content, layout_context)
  end

  def layout_pipeline(content, context)
    markdown_pipeline(context).call(content)[:output].to_s.html_safe
  end

  def basic_pipeline(context)
    HTML::Pipeline.new [
      Glynx::MustacheFilter
    ], context
  end

  def markdown_pipeline(context)
    HTML::Pipeline.new [
      Glynx::MustacheFilter,
      HTML::Pipeline::MarkdownFilter,
    ], context
  end

  def page_pipeline(content, context)
    basic_pipeline(context).call(content)[:output].to_s
  end

  def render_context
    context = OpenStruct.new attributes
    portal.merge_render_context!(context)
    { mustache: context }
  end
end
