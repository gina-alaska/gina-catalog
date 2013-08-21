class PhoneNumber < ActiveRecord::Base
  VALID_NAMES = %w{ work mobile alt }
  
  belongs_to :person
end
