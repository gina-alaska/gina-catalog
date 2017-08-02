class Catalog::OrganizationsController < CatalogController
  load_and_authorize_resource

  def index
    @q = Organization.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @organizations = @q.result(distinct: true).page(params[:page])
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
    @organization.aliases.build

    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @entry_organizations = @organization.entry_organizations.owner_portal(current_portal)
    save_referrer_location
  end

  def create
    @organization = Organization.new(organization_params)
    # TODO: make sure that organizations do not need to be associated with portals.

    respond_to do |format|
      if @organization.save
        flash[:success] = "Organization #{@organization.name} was successfully created."
        format.html { redirect_to catalog_organizations_path }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
        format.js { render 'create_error' }
      end
    end
  end

  def update
    respond_to do |format|
      if @organization.update_attributes(organization_params)
        flash[:success] = "Organization #{@organization.name} was successfully updated."
        format.html { redirect_to catalog_organizations_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    save_referrer_location

    respond_to do |format|
      if @organization.destroy
        flash[:success] = "Organization #{@organization.name} was successfully deleted."
        format.html { redirect_to catalog_organizations_path }
        format.json { head :no_content }
      else
        flash[:error] = @organization.errors.full_messages.join('<br />').html_safe
        format.html { redirect_to catalog_organizations_path }
        #        format.json { head :no_content }
      end
    end
  end

  protected

  def organization_params
    params.require(:organization).permit(
      :name, :acronym, :description, :category, :url, :active, :logo, :remove_logo,
      aliases_attributes: %i[id text _destroy]
    )
  end
end
