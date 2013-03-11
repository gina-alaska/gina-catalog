class Manager::PeopleController < ManagerController

  def index
    page = params[:page] || 1
    limit = params["limit"].nil? ? 30 : params["limit"]
    limit = 30000 if limit == "all"
    @search = search_params

    search = Person.search do
      fulltext search_params[:q] if search_params[:q]
      paginate per_page:(limit), page:(page)
    end

    @people = search.results

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
    end
  end

  def visible
    @person = Person.find(params[:id])
    @person.setups << current_setup

    respond_to do |format|
      format.html {
        if request.xhr?
          render partial: "action_buttons", locals: {item: @person}
        else
          redirect_to manager_person_spath
        end
      }
      format.js
    end
  end

  def hide
    @person = Person.find(params[:id])
    @person.setups.delete(current_setup)

    respond_to do |format|
      format.html {
        if request.xhr?
          render partial: "action_buttons", locals: {item: @person}
        else
          redirect_to manager_person_path
        end
      }
      format.js {
        render 'visible'
      }
    end
  end

  def all_visible
    current_setup.agencies << Person.where(id: params[:people_ids])

    respond_to do |format|
      format.html {
        if request.xhr?
          render nothing: true
        else
          redirect_to manager_people_path
        end
      }
    end
  end

  def all_hidden
    people_records = Person.where(id: params[:people_ids])
    current_setup.persons.delete(people_records)

    respond_to do |format|
      format.html {
        if request.xhr?
          render nothing: true
        else
          redirect_to manager_people_path
        end
      }
    end
  end

  protected

  def search_params
    params[:search] || {}
  end
end
