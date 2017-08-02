class Cms::Layout < ActiveRecord::Base
  include MustacheConcerns
  extend FriendlyId
  friendly_id :name, use: :scoped, scope: :portal

  belongs_to :portal
  has_many :pages, foreign_key: 'cms_layout_id', dependent: :nullify

  validates :name, presence: true
  validates :slug, uniqueness: { scope: :portal_id }
  validate :check_handlebarjs_syntax

  def to_s
    name
  end

  def render(context = nil)
    return content if context.nil?
    basic_pipeline(context).call(content)[:output].to_s
  end
end
