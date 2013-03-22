class Admin::GeokeywordsController < AdminController
  def index
    @geokeywords = Geokeyword.all
  end
  
  def new
    @geokeyword = Geokeyword.new
  end
  
  def create
    @geokeyword = Geokeyword.new(params[:geokeyword])
    
    respond_to do |format|
      if @geokeyword.save
        format.html {
          flash[:success] = "Created #{@geokeyword.name}"
          redirect_to admin_geokeywords_path
        }
      else
        format.html {
          render 'new'
        }
      end
    end
  end
  
  def edit
    @geokeyword = Geokeyword.find(params[:id])
  end
  
  def update
    @geokeyword = Geokeyword.find(params[:id])
    
    respond_to do |format|
      if @geokeyword.update_attributes(params[:geokeyword])
        format.html {
          flash[:success] = "Updated #{@geokeyword.name}"
          redirect_to admin_geokeywords_path
        }
      else
        format.html {
          render 'new'
        }
      end
    end
  end  
  
  def destroy
    @geokeyword = Geokeyword.find(params[:id])
    
    respond_to do |format|
      if @geokeyword.destroy
        flash[:success] = "Deleted #{@geokeyword.name}"
      else
        flash[:error] = "Unable to delete #{@geokeyword.name}"
      end
      format.html {
        redirect_to admin_geokeywords_path
      }
    end    
  end
end
