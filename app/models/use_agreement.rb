class UseAgreement < ActiveRecord::Base
  belongs_to :portal
  has_many :entries

  validates_presence_of :title
  validates :title, length: { maximum: 255 }
  validates_presence_of :body
end
