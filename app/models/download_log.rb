class DownloadLog < ActiveRecord::Base
  searchkick word_start: [:file_name, :user]

  belongs_to :user
  belongs_to :entry
  belongs_to :portal
  belongs_to :attachment

  validates :file_name, length: { maximum: 255 }
end
