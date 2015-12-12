class Cms::Layout < ActiveRecord::Base
  include MustacheConcerns
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :portal
  has_many :pages, foreign_key: 'cms_layout_id'

  validates :name, presence: true
  validates :slug, uniqueness: { scope: :portal_id }
  validate :check_handlebarjs_syntax

  def to_s
    name
  end
  
  def render(context = nil)
    context ||= render_context(portal)
    basic_pipeline(context).call(content)[:output].to_s
  end
end
