class Favicon < ActiveRecord::Base
  attr_accessible :image_name, :image_uid, :setup, :image
  dragonfly_accessor :image

  belongs_to :setup
end
