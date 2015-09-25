class Cms::PageAttachment < ActiveRecord::Base
  belongs_to :page, class_name: 'Cms::Page'
  belongs_to :attachment, class_name: 'Cms::Attachment'

  acts_as_list scope: :page
end
