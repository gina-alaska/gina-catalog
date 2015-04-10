class Download < ActiveRecord::Base
  belongs_to :attachment
  has_one :entry, through: :attachment
end
