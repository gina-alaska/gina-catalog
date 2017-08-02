module CmsHelper
  def portal_analytics(tracking_id, namespace = 'default')
    return if tracking_id.blank?
    <<~EOJS
      ga('create', '#{tracking_id}', 'auto', '#{namespace}');
      ga('#{namespace}.send', 'pageview');
    EOJS
  end
end
