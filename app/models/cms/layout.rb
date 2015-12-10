class Cms::Layout < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :portal
  has_many :pages, foreign_key: 'cms_layout_id', dependent: :nullify

  validates :name, presence: true
  validates :slug, uniqueness: { scope: :portal_id }

  def to_s
    name
  end
end
