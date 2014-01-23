module ImportsExtension
  def import_log(activity='Import')
    where(activity: activity)
  end

  def create_import_log(log, activity='Import')
    create({ activity: activity, log: log })
  end    
  
  def import_errors
    import_log('ImportError')
  end
  
  def create_import_error(log, activity='ImportError')
    create_import_log(log, activity)
  end
  
  def create_agency_import_error(log)
    create_import_log(log, 'AgencyImportError')
  end
  
  def agency_import_errors
    import_log('AgencyImportError')
  end
end