class Manager::PortalsController < ManagerController
  load_and_authorize_resource

  def show; end

  def edit
    @portal = current_portal
    @portal.build_social_networks
    @portal.build_favicon if @portal.favicon.nil?
  end

  def update
    @portal = current_portal

    respond_to do |format|
      if @portal.update_attributes(portal_params)
        flash[:success] = 'The portal was successfully updated.'
        format.html { redirect_to manager_portal_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @portal.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def portal_params
    params.require(:portal).permit(:title, :acronym, :description, :by_line,
                                   :contact_email, :analytics_account,
                                   social_networks_attributes: %i[id url social_network_config_id],
                                   favicon_attributes: %i[id image _destroy])
  end
end
