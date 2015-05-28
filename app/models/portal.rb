class Portal < ActiveRecord::Base
  acts_as_nested_set

  has_many :urls, class_name: 'PortalUrl'
  has_one :default_url, -> { where default: true }, class_name: 'PortalUrl'
  has_one :favicon, dependent: :destroy

  has_many :collections
  has_many :use_agreements
  has_many :permissions
  has_many :invitations
  has_many :download_logs
  has_many :map_layers

  has_many :users, through: :permissions
  has_many :activity_logs, as: :loggable
  has_many :social_networks, -> { joins(:social_network_config).order('social_network_configs.name ASC') }

  has_many :entry_portals
  has_many :entries, through: :entry_portals

  has_many :themes, foreign_key: 'owner_portal_id'

  scope :active, -> {}

  validates :title, presence: true
  validates :acronym, presence: true
  validate :single_default_url

  accepts_nested_attributes_for :urls, allow_destroy: true, reject_if: :blank_url
  accepts_nested_attributes_for :social_networks, allow_destroy: true
  accepts_nested_attributes_for :favicon, allow_destroy: true

  # validate :single_default_url

  def blank_url(attributed)
    attributed['url'].blank?
  end

  # def default_url
  #   self.urls.default_url.first.url
  # end

  def default_url_count
    urls.inject(0) { |c, v| v.default? ? c + 1 : c }
  end

  def single_default_url
    errors.add(:urls, 'cannot have more than one default url') if default_url_count > 1
  end

  def build_social_networks
    SocialNetworkConfig.order(name: :asc).each do |network|
      social_networks.find_or_initialize_by(social_network_config_id: network.id)
    end
  end
end
