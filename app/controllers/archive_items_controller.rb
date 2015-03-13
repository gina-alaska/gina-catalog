class ArchiveItemsController < ApplicationController
  load_and_authorize_resource

  def create
    @archive_item.user_id = current_user.id
    
    case archive_item_params[:archived_type]
    when 'Entry'
      entry = Entry.find(archive_item_params["archived_id"])
      entry.archive = @archive_item
      success_message = "Record #{entry.title} was successfully archived."
      error_message = "Record #{entry.title} was not archived."
      redirect_route = manager_entries_path
    else
      redirect_route = manager_path
    end

    respond_to do |format|
      if @archive_item.save
        flash[:success] = success_message
        format.html { redirect_to redirect_route }
      else
        flash[:error] = error_message       
        format.html { render action: 'show' }
      end
    end
  end
  
  protected

  def archive_item_params
    params.require(:archive_item).permit(:message, :archived_id, :archived_type)
  end  
end
