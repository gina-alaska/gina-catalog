class ActivityLog < ActiveRecord::Base
  belongs_to :loggable, polymorphic: true
  belongs_to :user
  belongs_to :portal
  belongs_to :entry

  validates :activity, presence: true
  validates :activity, length: { maximum: 255 }
  validates :loggable_type, length: { maximum: 255 }

  scope :downloads, -> { where(activity: 'Download') }
  scope :updates, -> { where(activity: 'Update') }
end
