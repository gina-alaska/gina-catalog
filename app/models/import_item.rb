class ImportItem < ActiveRecord::Base
  belongs_to :importable, polymorphic: true

  validates :import_id, uniqueness: { scope: :importable_type }

  scope :by_type, ->(type) { where(importable_type: type) }
  scope :contacts, -> { by_type('Contact') }
  scope :entries, -> { by_type('Entry') }
  scope :collections, -> { by_type('Collection') }
  scope :regions, -> { by_type('Region') }
  scope :data_types, -> { by_type('DataType') }  
  scope :use_agreements, -> { by_type('UseAgreement') }
  scope :iso_topics, -> { by_type('IsoTopic') }
  scope :oid, ->(id) { where(import_id: id) }
end
