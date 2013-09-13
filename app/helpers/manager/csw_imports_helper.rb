module Manager::CswImportsHelper
  def humanize_import_error(error, value)
    error_text = case error
    when :start_date
      "Unable to parse start date"
    when :end_date
      "Unable to parse end date"
    when :agencies
      "Unknown agency"
    when :status
      "Unknown status"
    else
      "Unknown error"
    end
    
    content_tag(:dt, error_text) + content_tag(:dd, Array(value).first)
  end
end
