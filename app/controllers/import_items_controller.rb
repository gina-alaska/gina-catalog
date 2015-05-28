class ImportItemsController < ApplicationController
  def entries
    entry = ImportItem.entries.oid(params['id']).first

    respond_to do |format|
      format.html { redirect_to entry.importable }
    end
  end

  def downloads
    entry = ImportItem.entries.oid(params['id']).first
    attachment = entry.attachments.uuid(params['uuid']).first

    respond_to do |format|
      format.html { redirect_to attachment.importable }
    end
  end
end
