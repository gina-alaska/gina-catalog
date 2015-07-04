class ImportItemsController < ApplicationController
  def entries
    entry = ImportItem.entries.oid(params['id']).first

    respond_to do |format|
      format.html { redirect_to entry.importable }
    end
  end

  def downloads
    respond_to do |format|
      format.html { redirect_to sds_path(params['uuid']) }
    end
  end
end
