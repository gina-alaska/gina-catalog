class Notification < ActiveRecord::Base
  attr_accessible :title, :message, :icon_name, :expire_date, :message_type

  belongs_to :setups

  scope :global_or_local_to, Proc.new{ |setup|
      where("setup_id is null or setup_id = ?", setup.id)
    }
end
