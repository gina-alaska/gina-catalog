module Manager::CswImportsHelper
  def import_status_text(status)
    if status == "Finished"
      "Schedule Import"
    else
      status
    end
  end
end
