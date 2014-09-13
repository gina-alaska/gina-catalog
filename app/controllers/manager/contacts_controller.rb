class Manager::ContactsController < ManagerController
  def index
    @contacts = Contact.all

    respond_to do |format|
      format.html
      format.json { render json: @contacts }
    end
  end

  def show
  end

  def new
    @contact = Contact.new()
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        flash[:success] = "Contact #{@contact.name} was successfully created."
        format.html { redirect_to manager_contacts_path }
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(contact_params)
        flash[:success] = "Contact #{@contact.name} was successfully updated."
        format.html { redirect_to manager_contacts_path }
        format.json { head :nocontent }
      else
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      flash[:success] = "Contact #{@contact.name} was successfully deleted."
      format.html { redirect_to manager_contacts_path }
      format.json { head :no_content }
    end
  end
  
  protected
  
  def contact_params
    params.require(:contact).permit(:name, :email, :phone_number, :job_title)
  end
end
