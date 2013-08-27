class Page::Snippet < ActiveRecord::Base
  attr_accessible :content, :slug

  has_and_belongs_to_many :setups, join_table: 'setups_snippets'

  belongs_to :setup
  
  validates_presence_of :slug
end
