class DataType < ActiveRecord::Base
  include EntryDependentConcerns

  has_many :entry_data_types, dependent: :delete_all
  has_many :entries, through: :entry_data_types

  validates :name, presence: true
  validates :name, length: { maximum: 255 }
  validates :name, uniqueness: true

  validates :description, length: { maximum: 255 }

  def to_s
    name
  end
end
