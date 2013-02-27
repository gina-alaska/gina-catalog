class Page::Snippet < ActiveRecord::Base
  attr_accessible :content, :slug
  
  validates_presence_of :slug
end
