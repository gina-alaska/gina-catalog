class Cms::Snippet < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :portal

  def should_generate_new_friendly_id?
    if !slug? || name_changed?
      true
    else
      false
    end
  end

  def basic_pipeline(context = render_context)
    HTML::Pipeline.new [
      Glynx::MustacheFilter
    ], context
  end

  def render
    basic_pipeline.call(content)[:output].to_s
  end

  def render_context
    context = OpenStruct.new(attributes)
    portal.merge_render_context!(context)

    { mustache: context }
  end
end
