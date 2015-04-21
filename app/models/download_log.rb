class DownloadLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry
  belongs_to :portal

  validates :file_name, length: { maximum: 255 }
end
