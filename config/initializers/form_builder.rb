class ActionView::Helpers::FormBuilder
  alias :orig_label :label
 
  # add a '*' after the field label if the field is required
  def label(method, content_or_options = nil, options = nil, &block)
    if content_or_options && content_or_options.class == Hash
      options = content_or_options
    else
      content = content_or_options
    end
 
    validations = [ActiveModel::Validations::PresenceValidator, ActiveModel::Validations::InclusionValidator]
    required_mark = ''

    if object.class.validators_on(method).map(&:class).any? { |item| validations.include?(item) }
      required_mark = ' <span class="required" title="Required Field">*<span>'.html_safe
    end
 
    content ||= method.to_s.humanize
    content = content + required_mark
 
    self.orig_label(method, content.html_safe, options || {}, &block)
  end
end