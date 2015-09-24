class Cms::Attachment < ActiveRecord::Base
  belongs_to :portal

  attachment :file

  validates :name, presence: true

  def image?
    Refile.types[:image].content_type.include? file_content_type
  end
end
