class Catalog::ContactsController < ManagerController
  load_and_authorize_resource

  def index
    @q = Contact.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @contacts = @q.result(distinct: true).page(params[:page])
    @contacts = @contacts.used_by_portal(current_portal) unless params[:all].present?

    respond_to do |format|
      format.html
      format.json { render json: @contacts }
    end
  end

  def search
    # Ransack method
    #   query = params[:query].split(/\s+/)
    #   @q = Contact.search(name_or_email_or_job_title_cont_any: query)
    #   @contacts = @q.result(distinct: true)

    @contacts = Contact.search(params[:query])
    # render json: @contacts

    respond_to do |format|
      format.json
    end
  end

  def new
    @contact = Contact.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @entry_contacts = @contact.entry_contacts.owner_portal(current_portal)
    save_referrer_location
  end

  def create
    respond_to do |format|
      if @contact.save
        flash[:success] = "Contact #{@contact.name} was successfully created."
        format.html { redirect_to catalog_contacts_path }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
        format.js { render 'create_error' }
      end
    end
  end

  def update
    respond_to do |format|
      if @contact.update_attributes(contact_params)
        flash[:success] = "Contact #{@contact.name} was successfully updated."
        format.html { redirect_to catalog_contacts_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    save_referrer_location

    respond_to do |format|
      if @contact.destroy
        flash[:success] = "Contact #{@contact.name} was successfully deleted."
        format.html { redirect_to catalog_contacts_path }
        format.json { head :no_content }
      else
        flash[:error] = @contact.errors.full_messages.join('<br />').html_safe
        format.html { redirect_back_or_default catalog_contacts_path }
        #        format.json { head :no_content }
      end
    end
  end

  protected

  def contact_params
    params.require(:contact).permit(:name, :email, :phone_number, :job_title)
  end
end
