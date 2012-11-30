class Image < ActiveRecord::Base
  attr_accessible :description, :file_uid, :link_to_url, :title
end
