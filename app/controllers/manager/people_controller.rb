class Manager::PeopleController < ManagerController
  before_filter :authenticate_access_catalog!

  SUBMENU = '/layouts/manager/catalog_menu'
  PAGETITLE = 'Contacts'
  
  def index
    @page = page = params[:page] || 1
    @limit = limit = params["limit"].nil? ? 30 : params["limit"]
    @sort = sort = params[:sort] || "last_name"
    @sortdir = sortdir = params[:sort_direction] || "asc"
    @show_hidden = search_params[:show_hidden]
    @search = search_params

    @solr_search = Person.search do
      with :setup_ids, current_setup.id unless search_params[:show_hidden]
      fulltext search_params[:q] if search_params[:q]
      order_by sort, sortdir.to_sym
      paginate per_page:(limit), page:(page)
    end

    @total = @solr_search.total
    @people = @solr_search.results

    respond_to do |format|
      format.html
      format.json { render json: @people }
    end
  end

  def show
    @person = Person.find(params[:id])
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    @person.setups << current_setup

    if @person.save!
      respond_to do |format|
        flash[:success] = "Contact for #{@person.first_name} #{@person.last_name} was successfully created."
        format.html { redirect_to manager_people_path }
      end
    else
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.where(id: params[:id]).first

    if @person.update_attributes(params[:person])
      respond_to do |format|
        flash[:success] = "Contact for #{@person.first_name} #{@person.last_name} was successfully updated."
        format.html { redirect_to manager_people_path }
        format.json { head :nocontent }
      end
    else
      respond_to do |format|
        format.html { render action: "edit" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      flash[:success] = "Contact for #{@person.first_name} #{@person.last_name} was successfully deleted."
      format.html { redirect_to manager_people_path }
      format.json { head :no_content }
      format.js
    end
  end

  def visible
    @people = Person.where(id: params[:people_ids])
    current_setup.persons << @people
    @people.each(&:index) # remove when table refactor is done

    respond_to do |format|
      format.html {
        redirect_to manager_people_path
      }
      format.js { render 'visible' }
    end
  end

  def hidden
    @people = Person.where(id: params[:people_ids])
    current_setup.persons.destroy(@people)
    @people.each(&:index) # remove when table refactor is done

    respond_to do |format|
      format.html {
        redirect_to manager_people_path
      }
      format.js { render 'visible' }
    end
  end

  protected

  def search_params
    params[:search] || {}
  end
end
