class Tag < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :assets

  def to_s
    self.text
  end

  def self.match_or_new(text)
    if match = Tag.where("text ILIKE ?", text).first
      return match
    else
      return Tag.new(text: text)
    end
  end
end
