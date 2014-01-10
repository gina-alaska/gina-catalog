class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(setup_id: nil)
  end

  def dismiss
    @id = params["id"]
    @notification = Notification.find(@id)
    session["read_notifications"] ||= []
    session["read_notifications"] << @notification.id if @notification

    respond_to do |format|
      format.html { redirect_to "/" }
      format.js {render layout: false}
    end
  end
end
