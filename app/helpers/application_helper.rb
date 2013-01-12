module ApplicationHelper
  def avatar_url(user, size=48)
    default_url = "mm"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{CGI.escape(default_url)}"
  end
  
  def flashes
    flash.map { |type, content|
      content_tag(:div, content, :class => "alert alert-#{type}")
    }.join('').html_safe
  end
  
  def jsflashes
    flash.map { |type, content| "Ext.gina.Notify.show(\"#{type}\", \"#{content}\");"  }.join(' ')
  end
  
  def show_flash_messages
    dismiss = '<a class="close" data-dismiss="alert" href="#">X</a>'.html_safe
    flash.map do |type,content|
      content_tag(:div, :class => "alert fade in alert-#{type}") do
        dismiss + content
      end
    end.join(' ').html_safe
  end
  
  def add_js_errors_for(model)
    klass = model.class.to_s.underscore
    output = ''
    
    model.errors.each do |field,msg|
      output << "
        $('##{klass}_#{field}').parents('.control-group').addClass('error');
        $('##{klass}_#{field}').parents('.control-group').append(
          '#{content_tag :p, "<i class=\"icon-warning-sign\" /> ".html_safe + escape_javascript("#{field.to_s.humanize} #{h msg}"), :class => 'alert alert-error'}'
        );
      "
    end
    
    output.html_safe
  end
  
  def search_regions
    regions = {}

    Dir.glob(File.join(Rails.root, 'public/regions/*.geojson')) do |f|
      regions[File.basename(f, '.geojson')] = JSON.parse(File.read(f))
    end

    regions
  end
end
