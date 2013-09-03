class Page::Layout < ActiveRecord::Base
  attr_accessible :content, :name, :default

  before_destroy :default_check
  
  has_and_belongs_to_many :setups, join_table: 'page_layouts_setups'
  belongs_to :setup

  validates_uniqueness_of :name, scope: :setup_id

  def default_check
    !self.default? 
  end
end
