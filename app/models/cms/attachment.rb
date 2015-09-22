class Cms::Attachment < ActiveRecord::Base
  belongs_to :portal

  attachment :file
end
