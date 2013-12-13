class Manager::NotificationsController < ManagerController

  SUBMENU = '/layouts/manager/cms_menu'
  PAGETITLE = 'Notifications'

  def index
    @notifications = Notification.all
  end

  def show
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(params[:notification])

    if @notification.save
      respond_to do |format|
        flash[:success] = "Notification #{@notification.title} was successfully created."
        format.html { redirect_back_or_default manager_notifications_path }
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
        format.html { redirect_back_or_default manager_notifications_path }
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
      format.html { redirect_to manager_notifications_path }
      format.json { head :no_content }
      format.js
    end
  end
end
