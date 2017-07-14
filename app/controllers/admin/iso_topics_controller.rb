class Admin::IsoTopicsController < AdminController
  load_and_authorize_resource

  def index; end

  def new; end

  def edit; end

  def create
    respond_to do |format|
      if @iso_topic.save
        flash[:success] = "ISO topic #{@iso_topic.name} was created."
        format.html { redirect_to admin_iso_topics_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @iso_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @iso_topic.update_attributes(iso_topic_params)
        flash[:success] = "ISO topic #{@iso_topic.name} was updated."
        format.html { redirect_to admin_iso_topics_path }
        format.json { head :nocontent }
      else
        format.html { render action: 'edit' }
        format.json { render json: @iso_topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @iso_topic.destroy
        flash[:success] = "ISO topic #{@iso_topic.name} was successfully deleted."
        format.html { redirect_to admin_iso_topics_path }
        format.json { head :no_content }
      else
        flash[:error] = @iso_topic.errors.full_messages.join('<br />').html_safe
        format.html { redirect_to admin_iso_topics_path }
        #         format.json { head :no_content }
      end
    end
  end

  protected

  def iso_topic_params
    params.require(:iso_topic).permit(:name, :long_name, :iso_theme_code)
  end
end
