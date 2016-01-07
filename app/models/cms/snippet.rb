class Cms::Snippet < ActiveRecord::Base
  include MustacheConcerns
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :portal

  belongs_to :portal

  validates :name, presence: true
  validate :check_handlebarjs_syntax

  def should_generate_new_friendly_id?
    if !slug? || name_changed?
      true
    else
      false
    end
  end

  def render(context = nil)
    context ||= render_context(portal)
    basic_pipeline(context).call(content)[:output].to_s
  end
end
