class Manager::InvitationsController < ManagerController
  load_and_authorize_resource find_by: :uuid
  skip_authorize_resource only: [:accept]
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:error] = "We're sorry but the requested invitation is no longer available"
    redirect_to root_path
  end
  
  def new
    @invitation = current_site.invitations.build
    @invitation.build_permission
  end
  
  def resend
    InvitationMailer.invite_email(@invitation).deliver
    redirect_to manager_permissions_path, notice: "Invitation has been resent"
  end
  
  def accept
    if current_user.email == @invitation.email
      @permission = @invitation.permission
      @permission.user = current_user
      if @permission.save
        @invitation.destroy
        
        redirect_to manager_path, notice: "You have been granted access to #{current_site.title}"
      else
        flash[:error] = "An error was encountered while trying to accept the invitation, please email the administrator to resolve this problem"
        redirect_to root_path
      end
    else
      flash[:error] = "The email address associated with this account does not match the invitation address.  We are unable to give you access to #{current_site.title}"
      redirect_to root_path
    end
  end
  
  def create
    @invitation = current_site.invitations.build(invitation_params)
    
    respond_to do |format|
      if @invitation.save
        @invitation.permission.update_attribute(:site, current_site)
        InvitationMailer.invite_email(@invitation).deliver
        
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
        @invitation.permission.update_attribute(:site, current_site)
        InvitationMailer.invite_email(@invitation).deliver
        
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
  
  def set_invitation
    @invitation = Invitation.find_by_uuid(params[:id]) 
  end
  
  def invitation_params
    params.require(:invitation).permit(:name, :email, :message, :permission_attributes => Permission::AVAILABLE_ROLES.keys + [:id])
  end
end
