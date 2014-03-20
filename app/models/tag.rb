class Tag < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :assets

  has_many :catalog_tags
  has_many :catalogs, through: :catalog_tags

  searchable do
    text :text
    string :text do
      text.downcase.gsub(/[\.,]/, '').chomp.strip
    end

    integer :record_count do
      self.catalogs.count
    end

    boolean :highlight
  end

  def to_s
    self.text
  end
end
