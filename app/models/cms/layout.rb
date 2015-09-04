class Cms::Layout < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :portal

  validates :slug, { uniqueness: { scope: :portal_id } }

  def to_s
    name
  end
end
