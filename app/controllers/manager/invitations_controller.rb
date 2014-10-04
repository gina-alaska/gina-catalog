class Manager::InvitationsController < ManagerController
  load_and_authorize_resource
  
  def new
    @invitation = current_site.invitations.build
    @invitation.build_permission
  end
  
  def create
    @invitation = current_site.invitations.build(invitation_params)
    
    respond_to do |format|
      if @invitation.save
        format.html {
          flash[:notice] = "Invitation sent to #{@invitation.email}"
          redirect_to manager_permissions_path
        }
      else
        format.html {
          render :new
        }
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @invitation.update_attributes(invitation_params)
        format.html {
          flash[:notice] = "Invitation updated"
          redirect_to manager_permissions_path
        }
      else
        format.html {
          render :edit
        }
      end
    end
  end
  
  def destroy
    respond_to do |format|
      if @invitation.destroy
        format.html { 
          flash[:notice] = "Inviation for #{@invitation.email} has been removed"
          redirect_to manager_permissions_path
        }
      else
        format.html { 
          flash[:notice] = "There was a problem removing invitation for #{@invitation.email}"
          redirect_to manager_permissions_path
        }
      end
    end
  end
  
  protected
  
  def invitation_params
    params.require(:invitation).permit(:email, :message, :permission_attributes => Permission::AVAILABLE_ROLES.keys)
  end
end
