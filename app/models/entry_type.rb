class EntryType < ActiveRecord::Base
  include EntryDependentConcerns
  
  has_many :entries

  validates :name, presence: true
  validates :name, length: { maximum: 255 }
  validates :description, length: { maximum: 255 }
  validates :color, presence: true  
  validates :color, length: { maximum: 255 }  

  before_destroy :deletable?
  
  def deletable?
    self.entries.empty?
  end    
end
