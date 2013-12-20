class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(setup_id: nil)
  end

  def dismiss
    @notification = Notification.find(params["id"])
  end
end
