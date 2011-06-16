class Tag < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :assets

  def to_s
    self.text
  end
end
