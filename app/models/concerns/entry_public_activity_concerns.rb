module EntryPublicActivityConcerns
  extend ActiveSupport::Concern
  include PublicActivity::Model

  included do
    tracked owner: proc { |controller, _model| controller.send(:current_user) },
            entry_id: :id,
            parameters: :activity_params
  end

  def activity_params
    params = {}

    params[:use_agreement] = { id: use_agreement_id, display: use_agreement.try(:title) } if use_agreement_id_changed?
    %w[title description status type start_date end_date].each do |field|
      params[field.to_sym] = changed_activity(field)
    end

    params.reject { |_k, v| v.nil? }
  end

  def changed_activity(field)
    { display: attributes[field.to_s].try(:[], 0..50) } if changed_attributes.include?(field.to_s)
  end
end
