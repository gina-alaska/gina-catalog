class Page::Snippet < ActiveRecord::Base
  attr_accessible :content, :slug
  before_destroy :prevent_system_delete
  
  validates_presence_of :slug

  def prevent_system_delete
    !self.system_page?
  end
end
