class EntryMapLayer < ActiveRecord::Base
  belongs_to :entry
  belongs_to :map_layer

  include PublicActivity::Model

  tracked owner: proc { |controller, _model| controller.send(:current_user) },
          entry_id: :entry_id,
          parameters: :activity_params

  def to_s
    map_layer.name
  end

  def activity_params
    { map_layer: map_layer.to_global_id.to_s }
  end
end
