module EntryRelationConcerns
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  included do
    belongs_to :use_agreement
    belongs_to :entry_type

    has_many :attachments, dependent: :destroy
    has_many :bboxes, through: :attachments

    has_many :activity_logs, as: :loggable
    has_many :links, dependent: :destroy

    has_many :entry_organizations, validate: true, dependent: :destroy
    has_many :organizations, -> { uniq }, through: :entry_organizations
    has_many :primary_entry_organizations, -> { primary }, class_name: 'EntryOrganization'
    has_many :primary_organizations, -> { uniq }, through: :primary_entry_organizations, source: :organization
    has_many :funding_entry_organizations, -> { funding }, class_name: 'EntryOrganization'
    has_many :funding_organizations, -> { uniq }, through: :funding_entry_organizations, source: :organization
    has_many :other_entry_organizations, -> { other }, class_name: 'EntryOrganization'
    has_many :other_organizations, -> { uniq }, through: :other_entry_organizations, source: :organization

    has_many :entry_aliases, dependent: :destroy

    has_many :entry_collections, dependent: :destroy
    has_many :collections, through: :entry_collections

    has_many :entry_contacts, validate: true, dependent: :destroy
    has_many :contacts, through: :entry_contacts

    has_many :primary_entry_contacts, -> { primary }, class_name: 'EntryContact', dependent: :destroy
    has_many :primary_contacts, through: :primary_entry_contacts, source: :contact

    has_many :other_entry_contacts, -> { other }, class_name: 'EntryContact', dependent: :destroy
    has_many :other_contacts, through: :other_entry_contacts, source: :contact

    has_many :entry_iso_topics, dependent: :destroy
    has_many :iso_topics, through: :entry_iso_topics

    has_many :entry_data_types, dependent: :destroy
    has_many :data_types, through: :entry_data_types

    has_many :entry_portals, dependent: :destroy
    has_many :portals, -> { uniq }, through: :entry_portals

    has_many :entry_regions, dependent: :destroy
    has_many :regions, through: :entry_regions

    has_one :owner_entry_portal, -> { where owner: true }, class_name: 'EntryPortal', dependent: :destroy
    has_one :owner_portal, through: :owner_entry_portal, source: :portal, class_name: 'Portal'

    has_many :entry_map_layers, dependent: :destroy
    has_many :map_layers, through: :entry_map_layers

    has_many :download_logs, dependent: :destroy

    accepts_nested_attributes_for :entry_collections, allow_destroy: true
    accepts_nested_attributes_for :entry_contacts, allow_destroy: true
    accepts_nested_attributes_for :entry_organizations, allow_destroy: true
    accepts_nested_attributes_for :attachments, allow_destroy: true,
                                                reject_if: proc { |attachment| attachment['id'].blank? && attachment['file'].blank? }
    accepts_nested_attributes_for :links, allow_destroy: true,
                                          reject_if: proc { |link| link['url'].blank? }
    accepts_nested_attributes_for :entry_map_layers, allow_destroy: true
  end
end
