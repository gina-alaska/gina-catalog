class Page::Layout < ActiveRecord::Base
  attr_accessible :content, :name, :default
  
  has_and_belongs_to_many :setups, join_table: 'page_layouts_setups'
  belongs_to :setup
end
