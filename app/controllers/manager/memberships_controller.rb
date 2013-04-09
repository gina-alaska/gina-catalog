class Manager::MembershipsController < ManagerController
  before_filter :authenticate_access_permissions!

  SUBMENU = '/layouts/manager/permission_menu'
  PAGETITLE = 'Memberships'
  
	def index
    @memberships = current_setup.memberships.all
  end

  def new
    @membership = Membership.new(email: params["email"])
  end

  def create
    @membership = current_setup.memberships.build(membership_params)
    @site_title = current_setup.title
    
    respond_to do |format|
      if !current_setup.contact_email.blank? and @membership.save
        format.html do
          InviteMailer.invite_email(current_setup.default_invite, current_setup.contact_email, @site_title, @membership.email, params["add_text"], manager_url).deliver
          flash[:success] = "Created new membership for #{@membership.email}."
          redirect_to manager_memberships_path
        end
      else
        format.html do
          if current_setup.contact_email.blank?
            flash[:error] = 'No contact email, please edit the site setup and add one.'
          else
            flash[:error] = 'Error while trying to create membership'
          end
          render 'new'
        end
      end
    end
  end

  def edit
    @membership = current_setup.memberships.find(params[:id])
  end

  def update
    @membership = current_setup.memberships.find(params[:id])
    
    respond_to do |format|
      if @membership.update_attributes(membership_params)
        format.html do
          flash[:success] = "Updated membership for #{@membership.email}"
          redirect_to manager_memberships_path
        end
      else
        format.html do
          flash[:error] = 'Error while trying to update membership'
          render 'edit'
        end
      end
    end
  end

  def destroy
    @membership = current_setup.memberships.find(params[:id])

    if @membership.destroy
      flash[:success] = "Deleted membership for #{@membership.email}"
    else        
      flash[:error] = "Error while trying to delete membership"
    end
    
    respond_to do |format|
      format.html do
        redirect_to manager_memberships_path
      end
    end
  end

  protected
  
  def authenticate_manage_members!
    unless user_is_a_member? and current_member.can_manage_members?
      authenticate_user!
    end      
  end
  
  def membership_params
    mparams = params[:membership].slice(:email, :role_ids)
  end
end