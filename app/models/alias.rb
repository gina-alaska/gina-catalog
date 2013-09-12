class Alias < ActiveRecord::Base
  attr_accessible :text
  
  belongs_to :aliasable, polymorphic: true
end
