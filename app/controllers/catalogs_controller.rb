class CatalogsController < ApplicationController
  # caches_action :show, :layout => true, :if => lambda { |c| c.request.xhr? }
  # caches_action :show, :layout => false, :unless => lambda { |c| c.request.xhr? }
  #caches_action :search

  def show
    @item = Catalog.includes(:locations, :source_agency, :agencies, :data_source, :links, :tags, :geokeywords)
    @item = @item.includes({ :people => [ :addresses, :phone_numbers ] }).find(params[:id])

    respond_to do |format|
      format.html {
        if request.xhr?
          render :layout => false
        end
      }
      format.json { render :json => @item.as_json(:format => 'full') }
      format.tar_gz do
        send_file(@item.repo.archive_filenames[:tar_gz])
      end
      format.zip do
        send_file(@item.repo.archive_filenames[:zip])
      end
    end
  end

  def more_info
    @catalog = Catalog.includes(:locations, :source_agency, :agencies, :data_source, :links, :tags, :geokeywords)
    @catalog = @catalog.includes({ :people => [ :addresses, :phone_numbers ] }).find(params[:id])

    respond_to do |format|
      format.js
    end
  end
end
