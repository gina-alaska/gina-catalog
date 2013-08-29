class PhoneNumber < ActiveRecord::Base
  VALID_NAMES = %w{ work mobile alt }

  belongs_to :person

  scope :work_phone, where("phone_numbers.name = ?", "work")
end
