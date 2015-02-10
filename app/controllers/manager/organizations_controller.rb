class Manager::OrganizationsController < ManagerController
  load_and_authorize_resource

  def index
    @q = Organization.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @organizations = @q.result(distinct: true)
    @organizations = @organizations.used_by_portal(current_portal) unless params[:all].present?

    respond_to do |format|
      format.html
      format.json { render json: @organizations }
    end
  end

  # def show
  # end

  def search
    # Ransack method
    #    query = params[:query].split(/\s+/)
    #    @q = Organization.search(name_or_acronym_or_category_cont_any: query)
    #    @organizations = @q.result(distinct: true)
    @organizations = Organization.search(params[:query])
    # render json: @organizations

    respond_to do |format|
      format.json
    end
  end

  def new
    @organization = Organization.new
    @organization.aliases.build
  end

  def edit
  end

  def create
    @organization = Organization.new(organization_params)
    # TODO: make sure that organizations do not need to be associated with portals.

    respond_to do |format|
      if @organization.save
        flash[:success] = "Organization #{@organization.name} was successfully created."
        format.html { redirect_to manager_organization_path(@organization) }
      else
        format.html { render action: 'new' }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @organization.update_attributes(organization_params)
        flash[:success] = "Organization #{@organization.name} was successfully updated."
        format.html { redirect_to manager_organizations_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @organization.destroy
        flash[:success] = "Organization #{@organization.name} was successfully deleted."
        format.html { redirect_to manager_organizations_path }
        format.json { head :no_content }
      else
        flash[:error] = @organization.errors.full_messages.join('<br />').html_safe
        format.html { redirect_to manager_organizations_path }
        #        format.json { head :no_content }
      end
    end
  end

  protected

  def organization_params
    params.require(:organization).permit(
      :name, :acronym, :description, :category, :url, :active, :logo,
      aliases_attributes: [:id, :text, :_destroy])
  end
end
