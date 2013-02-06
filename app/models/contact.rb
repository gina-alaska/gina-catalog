class Contact < ActiveRecord::Base
  attr_accessible :email, :message, :name

  belongs_to :setups
end
