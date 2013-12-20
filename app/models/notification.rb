class Notification < ActiveRecord::Base
  attr_accessible :title, :message, :icon_name, :expire_date, :message_type

  belongs_to :setups
end
