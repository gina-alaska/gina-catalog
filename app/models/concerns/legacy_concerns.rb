module LegacyConcerns
  extend ActiveSupport::Concern

  included do
    has_one :import, as: :importable, class_name: 'ImportItem'
  end
end
