class Page::Layout < ActiveRecord::Base
  attr_accessible :content, :name, :default
  
  has_and_belongs_to_many :setups, class_name: 'Page::Layout', join_table: 'page_layouts_setups'
end
