class DataType < ActiveRecord::Base
  include EntryDependentConcerns

  has_many :entries

  validates :name, presence: true
  validates :name, length: { maximum: 255 }
  validates :description, length: { maximum: 255 }

  def to_s
    name
  end
end
