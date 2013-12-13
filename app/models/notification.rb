class Notification < ActiveRecord::Base
  attr_accessible :title, :message, :icon_name, :expire_date
end
