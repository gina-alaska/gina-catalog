class PhoneNumber < ActiveRecord::Base
  VALID_NAMES = %w{ day evening mobile }
  
  belongs_to :person
end
