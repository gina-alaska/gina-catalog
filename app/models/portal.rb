class Portal < ActiveRecord::Base
  include MustacheConcerns
  include CmsConcerns

  acts_as_nested_set

  has_many :urls, class_name: 'PortalUrl', dependent: :destroy

  has_one :favicon, dependent: :destroy

  has_many :collections, dependent: :destroy
  has_many :use_agreements
  has_many :permissions, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :download_logs, dependent: :destroy
  has_many :map_layers, dependent: :destroy

  # CMS related things
  has_many :cms_attachments, class_name: 'Cms::Attachment', dependent: :destroy
  has_many :layouts, class_name: 'Cms::Layout', dependent: :destroy
  has_many :pages, class_name: 'Cms::Page', dependent: :destroy
  has_many :snippets, class_name: 'Cms::Snippet', dependent: :destroy
  has_many :themes, class_name: 'Cms::Theme', dependent: :destroy
  belongs_to :active_cms_theme, class_name: 'Cms::Theme'
  belongs_to :default_cms_layout, class_name: 'Cms::Layout'

  has_many :users, through: :permissions
  has_many :activity_logs, as: :loggable
  has_many :social_networks, -> { joins(:social_network_config).order('social_network_configs.name ASC') }

  has_many :entry_portals, dependent: :destroy
  has_many :entries, through: :entry_portals, dependent: :destroy

  scope :active, -> {}

  validates :title, presence: true, uniqueness: true
  validates :acronym, presence: true, length: { maximum: 15 }, uniqueness: true
  # validate :single_default_url

  accepts_nested_attributes_for :urls, allow_destroy: true, reject_if: :blank_url
  accepts_nested_attributes_for :social_networks, allow_destroy: true
  accepts_nested_attributes_for :favicon, allow_destroy: true
  accepts_nested_attributes_for :permissions, allow_destroy: true

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

  def default_url
    urls.active_url.first
  end
end
