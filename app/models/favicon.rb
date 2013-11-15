class Favicon < ActiveRecord::Base
  attr_accessible :image_name, :image_uid, :setup, :image
  image_accessor :image

  belongs_to :setup
end
