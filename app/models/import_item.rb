class ImportItem < ActiveRecord::Base
  belongs_to :importable, polymorphic: true

  validates :import_id, uniqueness: { scope: :importable_type }
end
