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

  # CMS related things
  has_many :layouts, class_name: 'Cms::Layout'
  has_many :pages, class_name: 'Cms::Page'
  has_many :snippets, class_name: 'Cms::Snippet'
  has_many :themes, class_name: 'Cms::Themes'

  has_many :users, through: :permissions
  has_many :activity_logs, as: :loggable
  has_many :social_networks, -> { joins(:social_network_config).order('social_network_configs.name ASC') }

  has_many :entry_portals
  has_many :entries, through: :entry_portals

  scope :active, -> {}

  validates :title, presence: true, uniqueness: true
  validates :acronym, presence: true, length: { maximum: 15 }, uniqueness: true
  validate :single_default_url

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

  def merge_render_context!(context)
    context.portal = OpenStruct.new(attributes)
    context.snippet = ->(name) { snippets.where(name: name).first.try(:render) }
    context.latest_entries = entries.order(updated_at: :desc).limit(5).to_a
  end
end
