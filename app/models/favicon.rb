class Favicon < ActiveRecord::Base
  dragonfly_accessor :image

  belongs_to :portal
end
