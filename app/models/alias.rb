class Alias < ActiveRecord::Base
  belongs_to :aliasable, polymorphic: true, touch: true

  validates :text, uniqueness: { scope: :aliasable }
end
