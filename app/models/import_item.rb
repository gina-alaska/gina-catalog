class ImportItem < ActiveRecord::Base
  belongs_to :importable, polymorphic: true
end
