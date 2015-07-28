class EntryMapLayer < ActiveRecord::Base
  belongs_to :entry
  belongs_to :map_layer

  include PublicActivity::Model

  tracked :owner => proc {|controller, model| controller.send(:current_user)},
          :entry_id => :entry_id 

  def to_s
    map_layer.name
  end
end
