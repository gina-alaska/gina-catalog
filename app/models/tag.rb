class Tag < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :assets

  def to_s
    self.text
  end

  def self.match_or_create(text)
    if match = Tag.where("text ILIKE ?", text).first
      return match
    else
      return Tag.create(text: text)
    end
  end
end
