class Page::Snippet < ActiveRecord::Base
  attr_accessible :content, :slug
  
  include CatalogConcerns::SystemContent
  
  validates_presence_of :slug
end
