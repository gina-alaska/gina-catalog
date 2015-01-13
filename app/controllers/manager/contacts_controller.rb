class Manager::ContactsController < ManagerController
  load_and_authorize_resource

  def index
    @contacts = Contact.all

    respond_to do |format|
      format.html
      format.json { render json: @contacts }
    end
  end
  
  def search
    @contacts = Contact.where('name ilike ?', "%#{params[:query]}%")
    
    render json: @contacts
  end

  def new
    @contact = Contact.new()
  end

  def edit
  end

  def create
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

    respond_to do |format|    
      if @contact.destroy
        flash[:success] = "Contact #{@contact.name} was successfully deleted."
        format.html { redirect_to manager_contacts_path }
        format.json { head :no_content }     
      else
        flash[:error] = @agency.errors.full_messages.join('<br />'.html_safe)
        format.html { redirect_to manager_contacts_path }
#        format.json { head :no_content } 
      end
    end

  end
  
  protected
  
  def contact_params
    params.require(:contact).permit(:name, :email, :phone_number, :job_title)
  end
end
