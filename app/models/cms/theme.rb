class Cms::Theme < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :portal

  validates :name, presence: true
  validates :slug, uniqueness: { scope: :portal_id }

  def should_generate_new_friendly_id?
    if !slug? || name_changed?
      true
    else
      false
    end
  end

  def to_s
    name
  end
end
