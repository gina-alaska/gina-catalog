class IsoTopic < ActiveRecord::Base
  self.table_name = 'iso_topic_categories'
 
  validates :name, length: { maximum: 50 }
  validates :long_name, length: { maximum: 200 }  
  validates :iso_theme_code, length: { maximum: 3 }  
 
  def long_name_with_code
    "#{iso_theme_code} :: #{name.humanize} - #{long_name}"
  end
  
  def as_json(*opts)
    hash = super
    hash[:long_name_with_code] = long_name_with_code
    
    hash
  end
end
