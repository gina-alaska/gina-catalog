class Admin::NotificationsController < AdminController
  def index
    @notifications = Notification.where(setup_id: nil)
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(params[:notification])

    if @notification.save
      respond_to do |format|
        flash[:success] = "Notification #{@notification.title} was successfully created."
        format.html { redirect_back_or_default admin_notifications_path }
      end
    else
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @notification = Notification.find(params[:id])
  end

  def update
    @notification = Notification.where(id: params[:id]).first

    if @notification.update_attributes(params[:notification])
      respond_to do |format|
        flash[:success] = "Notification #{@notification.title} was successfully updated."
        format.html { redirect_back_or_default admin_notifications_path }
        format.json { head :nocontent }
      end
    else
      respond_to do |format|
        format.html { render action: "edit" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_to do |format|
      flash[:success] = "Notification #{@notification.title} was successfully deleted."
      format.html { redirect_to admin_notifications_path }
      format.json { head :no_content }
      format.js
    end
  end
end
