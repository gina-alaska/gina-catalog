class IsoTopic < ActiveRecord::Base
  set_table_name 'iso_topic_categories'
  
  def long_name_with_code
    "#{iso_theme_code} :: #{name.humanize} - #{long_name}"
  end
  
  def as_json(*opts)
    hash = super
    hash[:long_name_with_code] = long_name_with_code
    
    hash
  end
end
