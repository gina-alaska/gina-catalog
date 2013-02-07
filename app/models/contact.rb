class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :name

  belongs_to :setups
  validates_presence_of :name, :email, :message
end
