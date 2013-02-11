class Manager::ContactsController < ManagerController

  def index
    @contacts = @setup.contacts

    respond_to do |format|
      format.html
      format.json { render json: @contacts }
    end
  end

  def show
    @contact = @setup.contacts.where( id: params[:id] ).first
    
    respond_to do |format|
      format.html
    end
  end

  def destroy
    @contact = @setup.contacts.where( id: params[:id] ).first
    @contact.destroy

    respond_to do |format|
      flash[:success] = 'Contact was successfully deleted.'
      format.html { redirect_to manager_contacts_path }
      format.json { head :no_content }
    end
  end
  
end
