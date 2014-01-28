class Upload < ActiveRecord::Base
  attr_accessible :catalog_id, :downloadable, :file_name, :file_size, :file_uid, :name, :preview
end
