class SocialNetwork < ActiveRecord::Base
  belongs_to :social_network_config
  delegate :name, :icon, to: :social_network_config, allow_nil: true
  belongs_to :portal

  scope :active, -> { where.not(url: [nil, ""]) }

  validates :social_network_config_id, uniqueness: { scope: :portal_id }
end
