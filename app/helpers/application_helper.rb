module ApplicationHelper
  def flashes
    flash.map do |type, content|
      content_tag(:div, content_tag(:p, content), :class => "flash_message #{type}")
    end
  end
  def jsflashes
    '<script type="text/javascript">' +
      flash.map { |type, content| "Ext.ux.Notify.show(\"#{type}\", \"#{content}\");"  }.join(' ') +
    '</script>'
  end
end
